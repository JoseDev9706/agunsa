import 'dart:developer';

import 'package:agunsa/features/auth/data/models/user_model.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> getCurrentUserEmail();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      try {
        await Amplify.Auth.signOut();
      } catch (e) {
        log('Logout error - $e');
      }

      final result =
          await Amplify.Auth.signIn(username: email, password: password);

      if (result.isSignedIn) {
        final user = await Amplify.Auth.getCurrentUser();
        return UserModel(email: email, token: user.userId);
      } else {
        return UserModel(email: '', token: '');
      }
    } catch (e) {
      log('Logout error - $e');
      return UserModel(email: '', token: '');
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