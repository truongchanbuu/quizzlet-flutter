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

final class AddWordToTopic extends TopicEvent {
  final String topicId;
  final WordModel word;

  const AddWordToTopic({required this.topicId, required this.word});
}

final class RemoveWordFromTopic extends TopicEvent {
  final String topicId;
  final String wordId;

  const RemoveWordFromTopic({required this.topicId, required this.wordId});
}

final class StarWord extends TopicEvent {
  final WordModel word;
  const StarWord(this.word);
}
