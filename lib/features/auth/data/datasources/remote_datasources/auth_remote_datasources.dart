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

      if (session.isSignedIn) {
        final cognitoSession = session as CognitoAuthSession;
        final user = await Amplify.Auth.getCurrentUser();
        final accessToken =
            cognitoSession.userPoolTokensResult.value.accessToken.raw;

        log('Inicio sesion verificado: ${user.username}');

        if (Jwt.isExpired(accessToken)) {
          log('Sesión expirada para el usuario');
          return AuthFailure({"message": "Sesión expirada."});
        }

        // Extracción segura del email/username
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

        UserModel userModel = UserModel(
          email: email,
          token: accessToken,
          id: user.userId,
        );

        log('UserModel: ${userModel.userToJson()}');
        return AuthSuccess(userModel);
      } else {
        return AuthFailure({"message": "Sesión no iniciada."});
      }
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
