import 'package:agunsa/features/auth/data/datasources/remote_datasources/auth_remote_datasources.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Correo o y contraseña no pueden estar vacíos');
    }
    return remoteDataSource.login(email, password);
  }

  @override
  Future<void> logout() async {
    // Implementación de logout
  }
  
  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUserEmail();
  }
}