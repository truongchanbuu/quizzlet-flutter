import 'package:json_annotation/json_annotation.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/user_answer.dart';

part 'user_answer.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class UserAnswerModel extends UserAnswerEntity {
  const UserAnswerModel({
    required super.topicId,
    required super.wordId,
    required super.userAnswer,
    required super.correctAnswer,
  });

  factory UserAnswerModel.fromEntity(UserAnswerEntity entity) {
    return UserAnswerModel(
      topicId: entity.topicId,
      wordId: entity.wordId,
      userAnswer: entity.userAnswer,
      correctAnswer: entity.correctAnswer,
    );
  }

  UserAnswerEntity toEntity() {
    return UserAnswerEntity(
      topicId: topicId,
      wordId: wordId,
      userAnswer: userAnswer,
      correctAnswer: correctAnswer,
    );
  }

  factory UserAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$UserAnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserAnswerModelToJson(this);
}
