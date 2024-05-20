part of 'flash_card_learning_bloc.dart';

sealed class FlashCardLearningEvent extends Equatable {
  const FlashCardLearningEvent();

  @override
  List<Object> get props => [];
}

final class LoadFlashCardEvent extends FlashCardLearningEvent {
  final List<WordModel> words;
  const LoadFlashCardEvent(this.words);
}

final class UpdateStudyingSwipe extends FlashCardLearningEvent {
  final WordModel word;

  const UpdateStudyingSwipe({required this.word});
}

final class UpdateLearnedSwipe extends FlashCardLearningEvent {
  final WordModel word;

  const UpdateLearnedSwipe({required this.word});
}
