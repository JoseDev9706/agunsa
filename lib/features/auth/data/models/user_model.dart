import 'package:agunsa/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({required email, required token, required id})
      : super(email: email, token: token, id: id);
  factory UserModel.fromCognito(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      token: json['token'] as String,
      id: json['id'] as String?,
    );
  }
  
  userToJson() => {"email": email, "token": token, "id": id};
 

 
}
