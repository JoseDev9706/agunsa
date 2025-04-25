import 'dart:developer';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

abstract class ProfileRemoteDatasource {
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required SignInResult isNeedPasswordConfirmation,
  });

  Future<void> deleteAccount();
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required SignInResult isNeedPasswordConfirmation,
  })async {
  try {
   final result = await Amplify.Auth.confirmSignIn(
      confirmationValue: newPassword,
    );
      // if (result.isSignedIn) {
      //   await Amplify.Auth.updatePassword(
      //     newPassword: newPassword,
      //     oldPassword: oldPassword,
      //   );
      // } else {
      //   log('User is not signed in');
      //   return;
      // }
    log('Password updated successfully: $result');
  } on AuthException catch (e) {
    safePrint('Error updating password: ${e.message}');
  }
  }
  
  @override
  Future<void> deleteAccount() {
    // TODO: implement deleteAccount
    throw UnimplementedError();
  }
 }