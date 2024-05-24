import 'package:equatable/equatable.dart';

class UserAnswerEntity extends Equatable {
  final String topicId;
  final String wordId;
  final String? userAnswer;
  final String correctAnswer;

  const UserAnswerEntity({
    required this.topicId,
    required this.wordId,
    required this.userAnswer,
    required this.correctAnswer,
  });

  @override
  List<Object?> get props => [topicId, wordId, userAnswer, correctAnswer];
}
