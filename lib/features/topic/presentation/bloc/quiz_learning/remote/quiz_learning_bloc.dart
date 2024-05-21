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
      _currentWordIndex = 0;
      emit(QuizInProgress(
        currentWordIndex: _currentWordIndex,
        correctAnswers: const [],
        wrongAnswers: const [],
      ));
    });
  }
}
