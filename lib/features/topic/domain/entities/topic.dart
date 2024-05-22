import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

class TopicEntity extends Equatable {
  final String topicId;
  final String topicName;
  final String? topicDesc;
  final bool isPublic;
  final List<WordModel> words;
  final DateTime createdAt;
  final DateTime? lastAccess;
  final String createdBy;

  const TopicEntity({
    required this.topicId,
    required this.topicName,
    this.topicDesc,
    required this.isPublic,
    required this.words,
    required this.lastAccess,
    required this.createdBy,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [topicId, topicName, isPublic, words, createdBy, lastAccess, createdAt];
}
