import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class CheckSession {
  final AuthRepository _authRepository;
  CheckSession(this._authRepository);

  Future<Either<Exception, AuthResult>> call() {
    return _authRepository.fecthAuthSession();
  }
}