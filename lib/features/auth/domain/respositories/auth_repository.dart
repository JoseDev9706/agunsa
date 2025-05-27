import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<UserEntity?> getCurrentUser();
  Future<Either<AuthFailure, Unit>> logout();
  Future<Either<Exception, AuthResult>> fecthAuthSession();
}
