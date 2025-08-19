import 'package:agunsa/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? displayName;
  final String? familyName;
  UserModel({required email, required token, required id, this.displayName, this.familyName, })
      : super(email: email, token: token, id: id, displayName:displayName, familyName:familyName ) ;
  factory UserModel.fromCognito(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String,
      token: json['token'] as String,
      id: json['id'] as String?,
      displayName: json['displayName'] as String?,
      familyName: json['familyName'] as String?,
    );
  }
  
  userToJson() => {"email": email, "token": token, "id": id, "displayName": displayName, "familyName": familyName,};
 

 
}
