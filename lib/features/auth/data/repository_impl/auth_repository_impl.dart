import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/data/datasources/remote_datasources/auth_remote_datasources.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';

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
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUserEmail();
  }
}
