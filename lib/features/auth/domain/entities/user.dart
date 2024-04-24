import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String email;
  final String password;
  final String? username;
  final DateTime? dateOfBirth;
  final String? avatarUrl;

  const UserEntity({
    required this.email,
    required this.password,
    this.username,
    this.dateOfBirth,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
        email,
        password,
        username,
        avatarUrl,
      ];
}
