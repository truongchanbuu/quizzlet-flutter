import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';

abstract class TopicRepository {
  // Topic
  Stream<List<TopicModel>> topics();
  Future<DataState<List<TopicModel>>> getTopicsByEmail(String email);
  Future<DataState<void>> createTopic(TopicModel topic);
  Future<DataState<void>> editTopic(TopicModel editedTopic);
  Future<DataState<void>> deleteTopic(String topicId);

  // Word
  Future<DataState<void>> createWord(WordModel word);
  Future<DataState<void>> deleteWord(String wordId);
  Future<DataState<void>> editWord(String wordId);
  Future<DataState<void>> addWordToTopic(String topicId, WordModel word);
  Future<DataState<void>> editWordInTopic(String topicId, WordModel editedWord);
  Future<DataState<void>> removeWordFromTopic(String topicId, String wordId);
  Future<DataState<void>> starWord(
      String email, String topicId, WordModel word);
  Future<DataState<void>> unStarWord(
      String email, String topicId, WordModel word);
  Future<DataState<List<WordModel>>> getStarredWords(
      String email, String topicId);

  // Folder
  Stream<List<FolderModel>> folders();
  Future<DataState<List<FolderModel>>> getFoldersByEmail(String email);
  Future<DataState<void>> createFolder(FolderModel folder);
  Future<DataState<void>> editFolder(FolderModel editedFolder);
  Future<DataState<void>> deleteFolder(String folderId);
  Future<DataState<void>> addTopicsToFolder(
      String folderId, List<String> topicIds);
  Future<DataState<void>> removeTopicsFromFolder(
      String folderId, List<String> topicIds);
}
