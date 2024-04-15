class User {
  final String id;
  final String email;
  final String password;
  final String? avatarUrl;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.avatarUrl,
  });
}
