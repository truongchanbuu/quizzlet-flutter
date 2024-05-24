part of 'word_bloc.dart';

sealed class WordEvent extends Equatable {
  const WordEvent();

  @override
  List<Object> get props => [];
}

final class GetStarredWords extends WordEvent {
  final String email;
  final String topicId;

  const GetStarredWords(this.email, this.topicId);
}

final class StarWord extends WordEvent {
  final WordModel word;
  final String topicId;
  final String email;
  const StarWord({
    required this.email,
    required this.word,
    required this.topicId,
  });
}

final class UnStarWord extends WordEvent {
  final WordModel word;
  final String email;
  final String topicId;
  const UnStarWord({
    required this.email,
    required this.word,
    required this.topicId,
  });
}
