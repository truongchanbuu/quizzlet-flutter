import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/user_answer.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/result/domain/entities/result.dart';

part 'result.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class ResultModel extends ResultEntity {
  const ResultModel({
    required super.email,
    required super.topicId,
    required super.userAnswers,
    required super.totalQuestions,
    required super.completionTime,
    required super.score,
  });
  factory ResultModel.fromEntity(ResultEntity entity) {
    return ResultModel(
      email: entity.email,
      topicId: entity.topicId,
      userAnswers: entity.userAnswers,
      totalQuestions: entity.totalQuestions,
      completionTime: entity.completionTime,
      score: entity.score,
    );
  }

  ResultEntity toEntity() {
    return ResultEntity(
      email: email,
      topicId: topicId,
      userAnswers: userAnswers,
      totalQuestions: totalQuestions,
      completionTime: completionTime,
      score: score,
    );
  }

  ResultModel copyWith({
    String? email,
    String? topicId,
    List<UserAnswerModel>? userAnswers,
    int? totalQuestions,
    Duration? completionTime,
    double? score,
  }) {
    return ResultModel(
      email: email ?? this.email,
      topicId: topicId ?? this.topicId,
      userAnswers: userAnswers ?? this.userAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      completionTime: completionTime ?? this.completionTime,
      score: score ?? this.score,
    );
  }

  factory ResultModel.fromJson(Map<String, dynamic> json) =>
      _$ResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResultModelToJson(this);
}
