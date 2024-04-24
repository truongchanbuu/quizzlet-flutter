import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/auth/domain/entities/user.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.password,
    super.username,
    super.dateOfBirth,
    super.avatarUrl,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      password: password,
      username: username,
      avatarUrl: avatarUrl,
      dateOfBirth: dateOfBirth,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      password: entity.password,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      dateOfBirth: entity.dateOfBirth,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? password,
    String? username,
    DateTime? dateOfBirth,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
