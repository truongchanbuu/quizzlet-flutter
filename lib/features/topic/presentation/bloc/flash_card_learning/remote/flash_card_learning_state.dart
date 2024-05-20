part of 'flash_card_learning_bloc.dart';

sealed class FlashCardLearningState extends Equatable {
  final LearnState status;
  const FlashCardLearningState({required this.status});

  @override
  List<Object> get props => [];
}

final class FlashCardLearningInitial extends FlashCardLearningState {
  const FlashCardLearningInitial({super.status = LearnState.notLearn});
}

final class FlashCardStudying extends FlashCardLearningState {
  const FlashCardStudying({super.status = LearnState.learning});
}

final class FlashCardLearned extends FlashCardLearningState {
  const FlashCardLearned({super.status = LearnState.learned});
}
