part of 'topic_bloc.dart';

sealed class TopicEvent extends Equatable {
  const TopicEvent();

  @override
  List<Object> get props => [];
}

final class GetTopics extends TopicEvent {
  final List<TopicModel> topics;
  const GetTopics(this.topics);
}

final class GetTopicsByUser extends TopicEvent {
  final String email;

  const GetTopicsByUser(this.email);
}

final class CreateTopic extends TopicEvent {
  final TopicModel topic;
  const CreateTopic(this.topic);
}

final class EditTopic extends TopicEvent {
  final TopicModel editedTopic;
  const EditTopic(this.editedTopic);
}

final class RemoveTopic extends TopicEvent {
  final String topicId;
  const RemoveTopic(this.topicId);
}

final class GetTopicsByName extends TopicEvent {
  final String name;

  const GetTopicsByName(this.name);
}
