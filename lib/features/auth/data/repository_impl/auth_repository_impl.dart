import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/data/datasources/remote_datasources/auth_remote_datasources.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthResult> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Correo y contraseña no pueden estar vacíos');
    }
    return remoteDataSource.login(email, password);
  }

  @override
  Future<Either<AuthFailure, Unit>> logout() async {
    try {
      await remoteDataSource.logout();
      
      return const Right(unit);
    } catch (e) {
      return Left(AuthFailure({"message": e.toString()}));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUserEmail();
  }

  @override
  Future<Either<Exception, AuthResult>> fecthAuthSession() async {
    try {
      final result = await remoteDataSource.checkSession();
      return Right(result);
    } catch (e) {
      return Left(Exception('Error al verificar la sesión: $e'));
    }
  }
}
