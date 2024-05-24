import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';

part 'word_event.dart';
part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final TopicRepository _topicRepository;

  WordBloc(this._topicRepository) : super(WordInitial()) {
    on<StarWord>((event, emit) async {
      try {
        var dataState = await _topicRepository.starWord(
            event.email, event.topicId, event.word);

        if (dataState is DataFailed) {
          emit(WordStarFailed());
        } else {
          emit(WordStarred());
        }
      } catch (e) {
        emit(WordStarFailed());
      }
    });

    on<UnStarWord>((event, emit) async {
      try {
        var dataState = await _topicRepository.unStarWord(
            event.email, event.topicId, event.word);

        if (dataState is DataFailed) {
          emit(UnStarFailed());
        } else {
          emit(UnStarred());
        }
      } catch (e) {
        emit(UnStarFailed());
      }
    });

    on<GetStarredWords>((event, emit) async {
      try {
        var dataState =
            await _topicRepository.getStarredWords(event.email, event.topicId);

        if (dataState is DataFailed) {
          emit(GetStarredWordsFailed());
        } else if (dataState is DataSuccess && dataState.data != null) {
          emit(GetStarredWordsSuccess(dataState.data!));
        } else {
          emit(GettingStarredWords());
        }
      } catch (e) {
        emit(GetStarredWordsFailed());
      }
    });
  }
}
