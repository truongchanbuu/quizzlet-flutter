part of 'quiz_learning_bloc.dart';

sealed class QuizLearningState extends Equatable {
  const QuizLearningState();

  @override
  List<Object> get props => [];
}

final class QuizLearningInitial extends QuizLearningState {}

final class QuizLoading extends QuizLearningState {}

final class QuizLoaded extends QuizLearningState {
  final List<WordModel> words;
  final int currentIndex;
  final List<String> options;
  final String mode;
  final List<WordModel> correctAnswers;
  final List<WordModel> wrongAnswers;
  final bool isFinished;

  const QuizLoaded({
    required this.words,
    required this.currentIndex,
    required this.options,
    required this.mode,
    this.correctAnswers = const [],
    this.wrongAnswers = const [],
    this.isFinished = false,
  });
}

final class QuizCompletedState extends QuizLearningState {
  final List<WordModel> correctAnswers;
  final List<WordModel> wrongAnswers;

  const QuizCompletedState(this.correctAnswers, this.wrongAnswers);
}
