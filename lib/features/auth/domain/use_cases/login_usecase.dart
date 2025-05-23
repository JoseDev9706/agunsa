import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../display/providers/auth_providers.dart';

part 'login_usecase.g.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthResult> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
}