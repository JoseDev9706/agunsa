import 'package:agunsa/core/class/auth_result.dart';
import 'package:agunsa/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
}
