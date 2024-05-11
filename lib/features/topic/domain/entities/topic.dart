import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/word.dart';

class TopicEntity extends Equatable {
  final String topicId;
  final String topicName;
  final String? topicDesc;
  final bool isPublic;
  final String? folderId;
  final List<WordEntity> words;
  final DateTime createdAt;
  final String createdBy;

  const TopicEntity({
    required this.topicId,
    required this.topicName,
    this.topicDesc,
    required this.isPublic,
    this.folderId,
    this.words = const [],
    required this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [topicId, topicName, isPublic, folderId, words, createdBy, createdAt];
}
