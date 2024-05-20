import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/topic.dart';

part 'topic.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class TopicModel extends TopicEntity {
  const TopicModel({
    required super.topicId,
    required super.topicName,
    super.topicDesc,
    required super.words,
    required super.isPublic,
    required super.createdBy,
    required super.lastAccess,
    required super.createdAt,
  });

  TopicEntity toEntity() {
    return TopicEntity(
      topicId: topicId,
      topicName: topicName,
      topicDesc: topicDesc,
      isPublic: isPublic,
      createdBy: createdBy,
      createdAt: createdAt,
      words: words,
      lastAccess: lastAccess,
    );
  }

  factory TopicModel.fromEntity(TopicEntity entity) {
    return TopicModel(
      topicId: entity.topicId,
      topicName: entity.topicName,
      topicDesc: entity.topicDesc,
      isPublic: entity.isPublic,
      createdBy: entity.createdBy,
      lastAccess: entity.lastAccess,
      words: entity.words,
      createdAt: entity.createdAt,
    );
  }

  TopicModel copyWith({
    String? topicId,
    String? topicName,
    String? topicDesc,
    List<WordModel>? words,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? lastAccess,
    String? createdBy,
  }) {
    return TopicModel(
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      topicDesc: topicDesc ?? this.topicDesc,
      isPublic: isPublic ?? this.isPublic,
      lastAccess: lastAccess ?? this.lastAccess,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      words: words ?? this.words,
    );
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) =>
      _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}
