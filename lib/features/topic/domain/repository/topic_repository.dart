import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/folder.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/word.dart';

abstract class TopicRepository {
  // Topic
  Stream<List<TopicModel>> topics();
  Future<DataState<void>> createTopic(TopicModel topic);
  Future<DataState<void>> editTopic(String topicId, TopicModel editedTopic);
  Future<DataState<void>> deleteTopic(String topicId);

  // Word
  Future<DataState<void>> createWord(WordEntity word);
  Future<DataState<void>> deleteWord(String wordId);
  Future<DataState<void>> editWord(String wordId);
  Future<DataState<void>> addWordToTopic(String topicId, WordEntity word);
  Future<DataState<void>> editWordInTopic(
      String topicId, WordEntity edittedWord);
  Future<DataState<void>> removeWordFromTopic(String topicId, String wordId);

  // Folder
  Future<DataState<void>> createFolder(FolderEntity folder);
  Future<DataState<void>> deleteFolder(String folderId);
  Future<DataState<void>> addTopicToFolder(String topicId, String folderId);
  Future<DataState<void>> removeTopicFromFolder(
      String topicId, String folderId);
}
