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

final class StartQuiz extends QuizLearningEvent {}

class NextQuestionEvent extends QuizLearningEvent {}

class CheckAnswerEvent extends QuizLearningEvent {
  final String answer;

  const CheckAnswerEvent(this.answer);
}

class FinishQuizEvent extends QuizLearningEvent {}
