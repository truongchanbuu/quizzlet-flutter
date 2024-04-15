import 'package:quizzlet_fluttter/models/user.dart';

class Topic {
  final String id;
  final String name;
  final bool isPublic;
  final String? folderId;
  final DateTime createdAt;
  final User? createdBy;

  Topic({
    required this.id,
    required this.name,
    required this.isPublic,
    this.folderId,
    required this.createdAt,
    this.createdBy,
  });
}
