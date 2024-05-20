import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/folder.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/word.dart';
import 'package:quizzlet_fluttter/injection_container.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/topic/data/models/topic.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';

class TopicRepositoryImpl implements TopicRepository {
  final topicCollection = sl.get<FirebaseFirestore>().collection('topics');
  final folderCollection = sl.get<FirebaseFirestore>().collection('folders');
  final storage = sl.get<FirebaseStorage>();

  // Topic
  @override
  Stream<List<TopicModel>> topics() {
    return topicCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => TopicModel.fromJson(doc.data())).toList());
  }

  @override
  Future<DataState<List<TopicModel>>> getTopicsByEmail(String email) async {
    try {
      var topics =
          (await topicCollection.where('createdBy', isEqualTo: email).get())
              .docs
              .map((doc) => TopicModel.fromJson(doc.data()))
              .toList();

      return DataSuccess(data: topics);
    } on FirebaseException catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> createTopic(TopicModel topic) async {
    try {
      await topicCollection.doc(topic.topicId).set(topic.toJson());
      return const DataSuccess();
    } on FirebaseException catch (e) {
      debugPrint('Created failed: ${e.message}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> editTopic(TopicModel editedTopic) async {
    try {
      await topicCollection
          .doc(editedTopic.topicId)
          .update(editedTopic.toJson());
      return const DataSuccess();
    } on FirebaseException catch (e) {
      debugPrint('Updated failed: ${e.message}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> deleteTopic(String topicId) async {
    try {
      await topicCollection.doc(topicId).delete();

      return const DataSuccess();
    } on FirebaseException catch (e) {
      debugPrint('Deleted failed: ${e.message}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> addTopicToFolder(String topicId, String folderId) {
    // TODO: implement addTopicToFolder
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> addWordToTopic(String topicId, WordModel word) {
    // TODO: implement addWordToTopic
    throw UnimplementedError();
  }

  // Folder
  @override
  Stream<List<FolderModel>> folders() {
    return folderCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => FolderModel.fromJson(doc.data())).toList());
  }

  @override
  Future<DataState<void>> createFolder(FolderModel folder) async {
    try {
      await folderCollection.doc(folder.folderId).set(folder.toJson());
      return const DataSuccess();
    } on FirebaseException catch (e) {
      debugPrint('Created failed: ${e.message}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> editFolder(FolderModel editedFolder) async {
    try {
      await folderCollection
          .doc(editedFolder.folderId)
          .update(editedFolder.toJson());
      return const DataSuccess();
    } on FirebaseException catch (e) {
      debugPrint('Updated failed: ${e.message}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<void>> deleteFolder(String folderId) async {
    try {
      await folderCollection.doc(folderId).delete();

      return const DataSuccess();
    } on FirebaseException catch (e) {
      debugPrint('Deleted failed: ${e.message}');
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<DataState<List<FolderModel>>> getFoldersByEmail(String email) async {
    try {
      var folders =
          (await folderCollection.where('creator', isEqualTo: email).get())
              .docs
              .map((doc) => FolderModel.fromJson(doc.data()))
              .toList();

      return DataSuccess(data: folders);
    } on FirebaseException catch (e) {
      return DataFailed(
        error: DioException(
          requestOptions: RequestOptions(),
          error: e.code,
          message: e.message,
        ),
      );
    }
  }

  // Word
  @override
  Future<DataState<void>> createWord(WordModel word) {
    // TODO: implement createWord
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> deleteWord(String wordId) {
    // TODO: implement deleteWord
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> editWord(String wordId) {
    // TODO: implement editWord
    throw UnimplementedError();
  }

  @override
  Future<DataState<void>> editWordInTopic(
      String topicId, WordModel editedWord) {
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
