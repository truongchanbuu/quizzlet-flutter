import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';

part 'topic_event.dart';
part 'topic_state.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final TopicRepository _topicRepository;
  late final StreamSubscription<List<TopicModel>> _topicSubscription;

  TopicBloc(this._topicRepository) : super(TopicInitial()) {
    _topicSubscription = _topicRepository.topics().listen((topics) {
      add(GetTopics(topics));
    });

    on<GetTopics>((event, emit) {
      emit(AllTopicsLoaded(event.topics));
    });

    on<GetTopicsByUser>((event, emit) async {
      try {
        var dataState = await _topicRepository.getTopicsByEmail(event.email);

        if (dataState is DataFailed) {
          emit(TopicsLoadFailure(
              dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess && dataState.data != null) {
          emit(TopicsLoaded(dataState.data!));
        } else {
          emit(TopicLoading());
        }
      } catch (e) {
        emit(TopicsLoadFailure(e.toString()));
      }
    });

    on<CreateTopic>((event, emit) async {
      try {
        var dataState = await _topicRepository.createTopic(event.topic);

        if (dataState is DataFailed) {
          emit(CreateTopicFailed(
              dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(const CreateTopicSuccess());
        } else {
          emit(Creating());
        }
      } catch (e) {
        emit(CreateTopicFailed(e.toString()));
      }
    });

    on<RemoveTopic>((event, emit) async {
      try {
        var dataState = await _topicRepository.deleteTopic(event.topicId);

        if (dataState is DataFailed) {
          emit(DeleteTopicFailed(
              dataState.error!.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(const DeleteTopicSuccess());
        } else {
          emit(Deleting());
        }
      } catch (e) {
        emit(DeleteTopicFailed(e.toString()));
      }
    });

    on<EditTopic>((event, emit) async {
      try {
        var dataState = await _topicRepository.editTopic(event.editedTopic);

        if (dataState is DataFailed) {
          emit(UpdateTopicFailed(
              dataState.error!.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(const UpdateTopicSuccess());
        } else {
          emit(Updating());
        }
      } catch (e) {
        emit(UpdateTopicFailed(e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _topicSubscription.cancel();
    return super.close();
  }
}
