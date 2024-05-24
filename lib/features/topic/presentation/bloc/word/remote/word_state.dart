part of 'word_bloc.dart';

sealed class WordState extends Equatable {
  const WordState();

  @override
  List<Object> get props => [];
}

final class WordInitial extends WordState {}

final class WordStarred extends WordState {}

final class WordStarFailed extends WordState {}

final class UnStarred extends WordState {}

final class UnStarFailed extends WordState {}

final class GettingStarredWords extends WordState {}

final class GetStarredWordsFailed extends WordState {}

final class GetStarredWordsSuccess extends WordState {
  final List<WordModel> starredWords;

  const GetStarredWordsSuccess(this.starredWords);
}
