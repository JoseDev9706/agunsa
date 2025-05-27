import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase {
  final AuthRepository _authRepository;

  LogoutUsecase(this._authRepository);

  Future<Either<AuthFailure, Unit>> call()  {
   return  _authRepository.logout();
  }
}