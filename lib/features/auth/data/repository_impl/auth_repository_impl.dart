import 'package:agunsa/features/auth/data/datasources/remote_datasources/auth_remote_datasources.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';
import 'package:agunsa/features/auth/domain/respositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    final userModel = await remoteDataSource.login(email, password);
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    // Implementación de logout
  }
}