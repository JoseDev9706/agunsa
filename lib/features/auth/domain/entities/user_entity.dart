class UserEntity {
  final String email;
  final String token;
  final String? id;

  const UserEntity({
    required this.email,
    required this.token,
    this.id,
  });
}
