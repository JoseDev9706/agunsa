import 'package:agunsa/features/auth/data/models/user_model.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

sealed class AuthResult {}

class AuthSuccess extends AuthResult {
  final UserModel user;
  AuthSuccess(this.user);
}

class RequirePasswordChange extends AuthResult {
  final SignInResult nextStep;
  RequirePasswordChange(this.nextStep);
}

class AuthFailure extends AuthResult {
  final String message;
  AuthFailure(this.message);
}
