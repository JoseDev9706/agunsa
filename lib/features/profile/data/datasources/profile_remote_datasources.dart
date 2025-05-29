import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

abstract class ProfileRemoteDatasource {
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required SignInResult? isNeedPasswordConfirmation,
  });

  Future<void> deleteAccount();
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required SignInResult? isNeedPasswordConfirmation,
  }) async {
    Object result;
    try {
      if (isNeedPasswordConfirmation != null) {
        result = await Amplify.Auth.confirmSignIn(
          confirmationValue: newPassword,
        );
      } else {
        result = await Amplify.Auth.updatePassword(
            oldPassword: oldPassword, newPassword: newPassword);
      }

      log('Password updated successfully: $result');
    } on AuthException catch (e) {
      log('Error updating password: ${e.message}');
      throw Exception('Error updating password: ${e.message}');
    }
  }

  @override
  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }
}
