part of 'quiz_learning_bloc.dart';

sealed class QuizLearningState extends Equatable {
  const QuizLearningState();

  @override
  List<Object> get props => [];
}

final class QuizLearningInitial extends QuizLearningState {}

final class QuizLoading extends QuizLearningState {}

final class QuizInProgress extends QuizLearningState {
  final int currentWordIndex;
  List<WordModel> correctAnswers;
  List<WordModel> wrongAnswers;
  final String? selectedAnswer;

  QuizInProgress({
    required this.currentWordIndex,
    this.selectedAnswer,
    required this.correctAnswers,
    required this.wrongAnswers,
  });
}

final class QuizCompleted extends QuizLearningState {}

final class QuizError extends QuizLearningState {
  final String message;
  const QuizError(this.message);
}
