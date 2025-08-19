import 'dart:convert';
import 'dart:developer';

import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/data/models/user_model.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart'
    show
        CognitoAuthSession,
        CognitoFetchAuthSessionPluginOptions,
        CognitoSignInDetailsApiBased;
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode/jwt_decode.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResult> login(String email, String password);
  Future<UserModel> getCurrentUserEmail();
  Future<void> logout();
  Future<AuthResult> checkSession();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      await Amplify.Auth.signOut();

      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        log('User is signed in: ${user.username}');
        log('User ID: ${user.userId}');

        final session = await Amplify.Auth.fetchAuthSession(
            options: const FetchAuthSessionOptions(
                pluginOptions: CognitoFetchAuthSessionPluginOptions()));

        if (session.isSignedIn) {
          final cognitoSession = session as CognitoAuthSession;

          log('Access Token: ${cognitoSession.userPoolTokensResult.value.accessToken.raw}');
          final accessToken =
              cognitoSession.userPoolTokensResult.value.accessToken.raw;

          return AuthSuccess(
            UserModel(email: email, token: accessToken, id: user.userId),
          );
        } else {
          return AuthFailure({"message": "Sesión no iniciada correctamente."});
        }
      } else if (result.nextStep.signInStep.name ==
          'confirmSignInWithNewPassword') {
        return RequirePasswordChange(result);
      } else {
        return AuthFailure({"message": "Credenciales inválidas."});
      }
    } on AuthException catch (e) {
      return AuthFailure({
        "message": e.message,
        "underlyingException": e.underlyingException?.toString()
      });
    } catch (e) {
      // cualquier otro error inesperado
      return AuthFailure({"message": e.toString()});
    }
  }

  @override
  Future<UserModel> getCurrentUserEmail() async {
    final user = await Amplify.Auth.getCurrentUser();
    return UserModel(email: user.username, token: user.userId, id: user.userId);
  }

  @override
  Future<void> logout() async {
    await Amplify.Auth.signOut();
  }

  Future<bool> isSignedIn() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }

  @override
Future<AuthResult> checkSession() async {
  try {
    final session = await Amplify.Auth.fetchAuthSession(
      options: const FetchAuthSessionOptions(
        pluginOptions: CognitoFetchAuthSessionPluginOptions(),
      ),
    );

    if (!session.isSignedIn) {
      return AuthFailure({"message": "Sesión no iniciada."});
    }

    final cognitoSession = session as CognitoAuthSession;
    final user = await Amplify.Auth.getCurrentUser();
    final accessToken =
        cognitoSession.userPoolTokensResult.value.accessToken.raw;

    log('Inicio sesion verificado: ${user.username}');

    if (Jwt.isExpired(accessToken)) {
      log('Sesión expirada para el usuario');
      return AuthFailure({"message": "Sesión expirada."});
    }

    // 1) Email/username seguro
    String email = '';
    if (user.signInDetails is CognitoSignInDetailsApiBased) {
      email = (user.signInDetails as CognitoSignInDetailsApiBased).username;
    } else {
      try {
        email = user.username;
      } catch (e) {
        log('Error al obtener email: $e');
        email = user.username;
      }
    }
    log('Email obtenido: $email');

    // Helpers locales
    String? _getAttr(List<AuthUserAttribute> attrs, String key) {
      for (final a in attrs) {
        if (a.userAttributeKey.key == key) return a.value;
      }
      return null;
    }

    Map<String, dynamic> _decodeJwtPayload(String token) {
      try {
        final parts = token.split('.');
        if (parts.length != 3) return {};
        String payload = parts[1];
        switch (payload.length % 4) {
          case 2: payload += '=='; break;
          case 3: payload += '='; break;
        }
        final normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
        final bytes = base64.decode(normalized);
        return jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      } catch (_) {
        return {};
      }
    }

    // 2) Intentar primero con atributos de Cognito
    List<AuthUserAttribute> attrs = [];
    try {
      attrs = await Amplify.Auth.fetchUserAttributes();
    } catch (e) {
      log('No se pudieron obtener atributos: $e');
    }

    String? givenName =
        _getAttr(attrs, 'given_name') ?? _getAttr(attrs, 'custom:first_name');
    String? familyName =
        _getAttr(attrs, 'family_name') ?? _getAttr(attrs, 'custom:last_name');
    String? fullNameRaw = _getAttr(attrs, 'name');
    String? preferred = _getAttr(attrs, 'preferred_username');

    // 3) Fallback: claims del ID token si no hubo atributos
    if (givenName == null && familyName == null && fullNameRaw == null) {
      final idToken = cognitoSession.userPoolTokensResult.value.idToken.raw;
      final claims = _decodeJwtPayload(idToken);
      givenName ??= claims['given_name'] as String?;
      familyName ??= claims['family_name'] as String?;
      fullNameRaw ??= claims['name'] as String?;
      preferred ??= claims['preferred_username'] as String?;
    }

    // 4) Construir nombre completo y displayName
    final fullName = (fullNameRaw != null && fullNameRaw.trim().isNotEmpty)
        ? fullNameRaw.trim()
        : [
            if (givenName != null && givenName.trim().isNotEmpty)
              givenName.trim(),
            if (familyName != null && familyName.trim().isNotEmpty)
              familyName.trim(),
          ].join(' ').trim();

    final fallback =
        (email.isNotEmpty && email.contains('@')) ? email.split('@').first : user.username;

    final displayName = fullName.isNotEmpty ? fullName : (preferred ?? fallback);

    // 5) Logs solicitados
    log('given_name: ${givenName ?? '-'}');
    log('family_name: ${familyName ?? '-'}');
    log('name (completo): ${fullName.isNotEmpty ? fullName : '-'}');
    log('preferred_username: ${preferred ?? '-'}');
    log('displayName usado: $displayName');

    // 6) Tu modelo y retorno original
    final userModel = UserModel(
      email: email,
      token: accessToken,
      id: user.userId,
      displayName: displayName,
      familyName: familyName,
    );

    log('UserModel: ${userModel.userToJson()}');
    return AuthSuccess(userModel);
  } on AuthException catch (e) {
    return AuthFailure({
      "message": e.message,
      "underlyingException": e.underlyingException?.toString(),
    });
  } catch (e) {
    return AuthFailure({"message": e.toString()});
  }
}

}
