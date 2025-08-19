class UserEntity {
  final String email;
  final String token;
  final String? id;
  final String? displayName;
  final String? familyName;

  const UserEntity({
    required this.email,
    required this.token,
    this.id,
    this.displayName,
    this.familyName,
  });

  String get fullName {
    return '$displayName $familyName';
  }

}
