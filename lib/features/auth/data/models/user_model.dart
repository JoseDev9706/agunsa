import 'package:agunsa/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String token;

  UserModel({
    required this.id,
    required this.email,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      token: json['token'],
    );
  }

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        token: token,
      );
}