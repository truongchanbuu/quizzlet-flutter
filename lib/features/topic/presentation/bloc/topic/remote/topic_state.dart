part of 'topic_bloc.dart';

sealed class TopicState extends Equatable {
  const TopicState();

  @override
  List<Object> get props => [];
}

final class TopicInitial extends TopicState {}

final class TopicLoading extends TopicState {}

final class AllTopicsLoaded extends TopicState {
  final List<TopicModel> topics;

  const AllTopicsLoaded(this.topics);
}

final class TopicsLoaded extends TopicState {
  final List<TopicModel> topics;
  const TopicsLoaded(this.topics);
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

final class DeleteTopicSuccess extends TopicState {
  const DeleteTopicSuccess();
}

final class Deleting extends TopicState {}

final class DeleteTopicFailed extends TopicState {
  final String? message;
  const DeleteTopicFailed(this.message);
}

final class UpdateTopicSuccess extends TopicState {
  const UpdateTopicSuccess();
}

final class Updating extends TopicState {}

final class UpdateTopicFailed extends TopicState {
  final String? message;
  const UpdateTopicFailed(this.message);
}
