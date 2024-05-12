import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/learn_state.dart';

class WordEntity extends Equatable {
  final String wordId;
  final String terminology;
  final String meaning;
  final String? wordDesc;
  final String? phonetic;
  final String? illustratorUrl;
  final LearnState learnState;
  final bool starred;

  const WordEntity({
    required this.wordId,
    required this.terminology,
    required this.meaning,
    required this.wordDesc,
    this.phonetic,
    this.illustratorUrl,
    this.learnState = LearnState.notLearn,
    this.starred = false,
  });

  @override
  List<Object?> get props => [
        wordId,
        terminology,
        meaning,
        phonetic,
        wordDesc,
        illustratorUrl,
        learnState,
        starred
      ];
}
