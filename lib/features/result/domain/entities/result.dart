import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/user_answer.dart';

class ResultEntity extends Equatable {
  final String email;
  final String topicId;
  final List<UserAnswerModel> userAnswers;
  final int totalQuestions;
  final double score;
  final Duration completionTime;

  const ResultEntity({
    required this.email,
    required this.topicId,
    required this.userAnswers,
    required this.totalQuestions,
    required this.score,
    required this.completionTime,
  });

  @override
  List<Object?> get props =>
      [email, topicId, userAnswers, totalQuestions, score, completionTime];
}
