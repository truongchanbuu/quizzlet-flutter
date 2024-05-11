import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/learn_state.dart';

class WordEntity extends Equatable {
  final String wordId;
  final String english;
  final String vietnamese;
  final String? phonetic;
  final String? illustratorUrl;
  final LearnState learnState;
  final bool starred;

  const WordEntity({
    required this.wordId,
    required this.english,
    required this.vietnamese,
    this.phonetic,
    this.illustratorUrl,
    this.learnState = LearnState.notLearn,
    this.starred = false,
  });

  @override
  List<Object?> get props => [
        wordId,
        english,
        vietnamese,
        phonetic,
        illustratorUrl,
        learnState,
        starred
      ];
}
