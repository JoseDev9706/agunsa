import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/core/enum/auth_state.dart';
import 'package:agunsa/features/auth/display/providers/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authManagerProvider = Provider<AuthManager>((ref) {
  return AuthManager(ref);
});

class AuthManager {
  final Ref _ref;

  AuthManager(this._ref);

  Future<void> checkAndUpdateSession() async {
    final result = await _ref.read(checkSessionUseCaseProvider)();
    result.fold(
      (failure) => _handleFailure(failure as AuthFailure),
      (success) {
      if (success is AuthSuccess) {
        _handleSuccess(success);
      } else {
        _handleFailure(success as AuthFailure);
      }
    }
    );
  }

  void _handleSuccess(AuthSuccess success) {
    _ref.read(userProvider.notifier).state = success.user;
    _ref.read(authStateProvider.notifier).state = AuthState.signedIn;
  }

  void _handleFailure(AuthFailure failure) {
    _ref.read(userProvider.notifier).state = null;
    _ref.read(authStateProvider.notifier).state = AuthState.signedOut;
  }
}