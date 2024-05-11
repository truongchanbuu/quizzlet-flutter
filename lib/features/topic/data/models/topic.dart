import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/topic.dart';

part 'topic.g.dart';

@JsonSerializable()
class TopicModel extends TopicEntity {
  const TopicModel(
      {required super.topicId,
      required super.topicName,
      required super.isPublic,
      required super.createdBy,
      required super.createdAt});

  TopicEntity toEntity() {
    return TopicEntity(
        topicId: topicId,
        topicName: topicName,
        isPublic: isPublic,
        createdBy: createdBy,
        createdAt: createdAt);
  }

  factory TopicModel.fromEntity(TopicEntity entity) {
    return TopicModel(
        topicId: entity.topicId,
        topicName: entity.topicName,
        isPublic: entity.isPublic,
        createdBy: entity.createdBy,
        createdAt: entity.createdAt);
  }

  TopicModel copyWith({
    String? topicId,
    String? topicName,
    bool? isPublic,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return TopicModel(
      topicId: topicId ?? this.topicId,
      topicName: topicName ?? this.topicName,
      isPublic: isPublic ?? this.isPublic,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TopicModel.fromJson(Map<String, dynamic> json) => _$TopicModelFromJson(json);

  Map<String, dynamic> toJson() => _$TopicModelToJson(this);
}
