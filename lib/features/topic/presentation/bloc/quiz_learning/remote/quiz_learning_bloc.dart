import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

part 'quiz_learning_event.dart';
part 'quiz_learning_state.dart';

class QuizLearningBloc extends Bloc<QuizLearningEvent, QuizLearningState> {
  QuizLearningBloc() : super(QuizLearningInitial()) {
    on<QuizLearningEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
