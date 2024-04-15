import 'package:quizzlet_fluttter/models/learn_state.dart';

class Word {
  String id;
  String english;
  String vietnamese;
  String? description;
  String? illustrationUrl;
  LearnState learnState;
  bool starred;

  Word({
    required this.id,
    required this.english,
    required this.vietnamese,
    this.description,
    this.illustrationUrl,
    this.learnState = LearnState.notLearn,
    this.starred = false,
  });
}
