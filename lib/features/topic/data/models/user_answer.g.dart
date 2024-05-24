// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAnswerModel _$UserAnswerModelFromJson(Map json) => UserAnswerModel(
      topicId: json['topicId'] as String,
      wordId: json['wordId'] as String,
      userAnswer: json['userAnswer'] as String?,
      correctAnswer: json['correctAnswer'] as String,
    );

Map<String, dynamic> _$UserAnswerModelToJson(UserAnswerModel instance) =>
    <String, dynamic>{
      'topicId': instance.topicId,
      'wordId': instance.wordId,
      'userAnswer': instance.userAnswer,
      'correctAnswer': instance.correctAnswer,
    };
