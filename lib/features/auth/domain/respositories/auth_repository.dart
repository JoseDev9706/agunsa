import 'package:agunsa/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
}