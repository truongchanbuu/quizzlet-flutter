import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/folder.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/topic.dart';
import 'package:quizzlet_fluttter/features/topic/domain/entities/word.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';

class TopicRepositoryImpl implements TopicRepository {
  final topicCollection =
      GetIt.instance.get<FirebaseFirestore>().collection('topics');

  @override
  Stream<List<TopicEntity>> topics() {
    return topicCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => TopicEntity(
              topicId: doc.data()['topicId'],
              topicName: doc.data()['topicName'],
              isPublic: doc.data()['isPublic'],
              createdBy: doc.data()['createdBy'],
              createdAt: doc.data()['createdAt'],
            ))
        .toList());
  }

  @override
  Future<DataState<void>> addTopicToFolder(String topicId, String folderId) {
    // TODO: implement addTopicToFolder
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> addWordToTopic(String topicId, WordEntity word) {
    // TODO: implement addWordToTopic
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> createFolder(FolderEntity folder) {
    // TODO: implement createFolder
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> createTopic(TopicEntity topic) {
    // TODO: implement createTopic
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> createWord(WordEntity word) {
    // TODO: implement createWord
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> deleteFolder(String folderId) {
    // TODO: implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> deleteTopic(String topicId) {
    // TODO: implement deleteTopic
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> deleteWord(String wordId) {
    // TODO: implement deleteWord
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> editTopic(String topicId, TopicEntity editedTopic) {
    // TODO: implement editTopic
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> editWord(String wordId) {
    // TODO: implement editWord
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> editWordInTopic(
      String topicId, WordEntity edittedWord) {
    // TODO: implement editWordInTopic
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> removeTopicFromFolder(
      String topicId, String folderId) {
    // TODO: implement removeTopicFromFolder
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> removeWordFromTopic(String topicId, String wordId) {
    // TODO: implement removeWordFromTopic
    throw UnimplementedError();
  }
}
