import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

abstract class ProfileRepository {
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
  });

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required SignInResult isNeedPasswordConfirmation,
  });

  Future<void> deleteAccount();
}