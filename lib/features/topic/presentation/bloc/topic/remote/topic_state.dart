part of 'topic_bloc.dart';

sealed class TopicState extends Equatable {
  const TopicState();

  @override
  List<Object> get props => [];
}

final class TopicInitial extends TopicState {}

final class TopicLoading extends TopicState {}

final class TopicsLoadSuccess extends TopicState {
  final List<TopicModel> topics;

  const TopicsLoadSuccess(this.topics);
}

final class TopicsLoadFailure extends TopicState {
  final String error;

  const TopicsLoadFailure(this.error);
}

final class CreateTopicSuccess extends TopicState {
  const CreateTopicSuccess();
}

final class Creating extends TopicState {}

final class CreateTopicFailed extends TopicState {
  final String? message;
  const CreateTopicFailed(this.message);
}
