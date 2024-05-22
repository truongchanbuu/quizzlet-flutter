// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopicModel _$TopicModelFromJson(Map json) => TopicModel(
      topicId: json['topicId'] as String,
      topicName: json['topicName'] as String,
      topicDesc: json['topicDesc'] as String?,
      words: (json['words'] as List<dynamic>)
          .map((e) => WordModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      isPublic: json['isPublic'] as bool,
      createdBy: json['createdBy'] as String,
      lastAccess: json['lastAccess'] == null
          ? null
          : DateTime.parse(json['lastAccess'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TopicModelToJson(TopicModel instance) =>
    <String, dynamic>{
      'topicId': instance.topicId,
      'topicName': instance.topicName,
      'topicDesc': instance.topicDesc,
      'isPublic': instance.isPublic,
      'words': instance.words.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'lastAccess': instance.lastAccess?.toIso8601String(),
      'createdBy': instance.createdBy,
    };
