import 'package:quizzlet_fluttter/features/auth/domain/entities/user.dart';

class Topic {
  final String id;
  final String name;
  final bool isPublic;
  final String? folderId;
  final DateTime createdAt;
  final UserEntity? createdBy;

  Topic({
    required this.id,
    required this.name,
    required this.isPublic,
    this.folderId,
    required this.createdAt,
    this.createdBy,
  });
}
