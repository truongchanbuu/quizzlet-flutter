import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/learn_state.dart';

part 'flash_card_learning_event.dart';
part 'flash_card_learning_state.dart';

class FlashCardLearningBloc
    extends Bloc<FlashCardLearningEvent, FlashCardLearningState> {
  FlashCardLearningBloc() : super(const FlashCardLearningInitial()) {
    on<UpdateStudyingSwipe>((event, emit) {
      emit(const FlashCardStudying());
    });

    on<UpdateLearnedSwipe>((event, emit) {
      emit(const FlashCardLearned());
    });
  }
}
