part of 'quiz_learning_bloc.dart';

sealed class QuizLearningEvent extends Equatable {
  const QuizLearningEvent();

  @override
  List<Object> get props => [];
}

final class LoadQuiz extends QuizLearningEvent {
  final List<WordModel> words;
  final String mode;

  const LoadQuiz({required this.words, required this.mode});
}

final class AnswerQuiz extends QuizLearningEvent {
  final String answer;
  const AnswerQuiz(this.answer);
}

final class ChangeNextQuiz extends QuizLearningEvent {}

final class FinishQuiz extends QuizLearningEvent {}

final class ChangeLanguageMode extends QuizLearningEvent {
  final String mode;
  const ChangeLanguageMode(this.mode);
}
