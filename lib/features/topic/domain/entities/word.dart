import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/learn_state.dart';

class WordEntity extends Equatable {
  final String wordId;
  String terminology;
  String meaning;
  String? wordDesc;
  String? phonetic;
  String? illustratorUrl;
  LearnState learnState;

  WordEntity({
    required this.wordId,
    required this.terminology,
    required this.meaning,
    required this.wordDesc,
    this.phonetic,
    this.illustratorUrl,
    this.learnState = LearnState.notLearn,
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
      ];
}
