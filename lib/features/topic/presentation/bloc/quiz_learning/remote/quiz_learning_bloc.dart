import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

part 'quiz_learning_event.dart';
part 'quiz_learning_state.dart';

class QuizLearningBloc extends Bloc<QuizLearningEvent, QuizLearningState> {
  final TopicModel topic;
  final String mode;
  int _currentWordIndex = 0;

  QuizLearningBloc({required this.topic, required this.mode})
      : super(QuizLearningInitial()) {
    on<StartQuiz>((event, emit) {
      emit(QuizInProgress(
        currentWordIndex: 0,
        correctAnswers: [],
        wrongAnswers: [],
      ));
    });

    on<CheckAnswer>((event, emit) {
      final currentState = state as QuizInProgress;
      final currentWord = topic.words[_currentWordIndex];
      final correctAnswer =
          mode == 'en-vie' ? currentWord.meaning : currentWord.terminology;

      if (event.answer == correctAnswer) {
        currentState.correctAnswers.add(currentWord);
      } else {
        currentState.wrongAnswers.add(currentWord);
      }

      emit(QuizInProgress(
        currentWordIndex: _currentWordIndex,
        correctAnswers: currentState.correctAnswers,
        wrongAnswers: currentState.wrongAnswers,
        selectedAnswer: event.answer,
      ));

      Future.delayed(const Duration(seconds: 2), () {
        add(NextQuestion());
      });
    });

    on<NextQuestion>((event, emit) {
      if (_currentWordIndex < topic.words.length - 1) {
        _currentWordIndex++;
        emit(QuizInProgress(
          currentWordIndex: _currentWordIndex,
          correctAnswers: (state as QuizInProgress).correctAnswers,
          wrongAnswers: (state as QuizInProgress).wrongAnswers,
        ));
      } else {
        emit(QuizCompleted());
      }
    });
  }
}
