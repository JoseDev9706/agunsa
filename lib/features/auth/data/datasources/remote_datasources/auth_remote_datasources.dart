import 'dart:developer';

import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/data/models/user_model.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResult> login(String email, String password);
  Future<UserModel> getCurrentUserEmail();
  Future<void> logout();
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
        return AuthSuccess(UserModel(email: email, token: user.userId));
      } else if (result.nextStep.signInStep.name ==
          'confirmSignInWithNewPassword') {
        return RequirePasswordChange(result);
      } else {
        return AuthFailure("Credenciales inválidas.");
      }
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }


  @override
  Future<UserModel> getCurrentUserEmail() async {
    final user = await Amplify.Auth.getCurrentUser();
    return UserModel(email: user.username, token: user.userId);
  }

  @override
  Future<void> logout() async {
    await Amplify.Auth.signOut();
  }

  Future<bool> isSignedIn() async {
    final session = await Amplify.Auth.fetchAuthSession();
    return session.isSignedIn;
  }
}