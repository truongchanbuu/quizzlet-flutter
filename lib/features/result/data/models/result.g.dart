// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResultModel _$ResultModelFromJson(Map json) => ResultModel(
      email: json['email'] as String,
      topicId: json['topicId'] as String,
      userAnswers: (json['userAnswers'] as List<dynamic>)
          .map((e) =>
              UserAnswerModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      totalQuestions: json['totalQuestions'] as int,
      completionTime: Duration(microseconds: json['completionTime'] as int),
      score: (json['score'] as num).toDouble(),
    );

Map<String, dynamic> _$ResultModelToJson(ResultModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'topicId': instance.topicId,
      'userAnswers': instance.userAnswers.map((e) => e.toJson()).toList(),
      'totalQuestions': instance.totalQuestions,
      'score': instance.score,
      'completionTime': instance.completionTime.inMicroseconds,
    };
