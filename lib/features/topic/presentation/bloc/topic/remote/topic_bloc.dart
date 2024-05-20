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
      emit(TopicsLoadSuccess(event.topics));
    });

    on<CreateTopic>((event, emit) async {
      var dataState = await _topicRepository.createTopic(event.topic);

      if (dataState is DataFailed) {
        emit(CreateTopicFailed(
            dataState.error?.message ?? 'There is something wrong'));
      } else if (dataState is DataSuccess) {
        emit(const CreateTopicSuccess());
      } else {
        emit(Creating());
      }
    });
  }

  @override
  Future<void> close() {
    _topicSubscription.cancel();
    return super.close();
  }
}
