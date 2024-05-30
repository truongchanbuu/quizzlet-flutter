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
  final starredWordsCollection =
      sl.get<FirebaseFirestore>().collection('starred_words');
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
  Future<DataState<void>> starWord(
      String email, String topicId, WordModel word) async {
    try {
      var userStarredWordDoc =
          starredWordsCollection.doc(email).collection('topics').doc(topicId);
      var snapshot = await userStarredWordDoc.get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> words = data['words'] ?? [];

        if (!words.any((wordInDoc) => wordInDoc['wordId'] == word.wordId)) {
          words.add(word.toJson());
          await userStarredWordDoc.update({'words': words});
        }
      } else {
        await userStarredWordDoc.set({
          'words': [word.toJson()]
        });
      }

      return const DataSuccess();
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
  Future<DataState<void>> unStarWord(
      String email, String topicId, WordModel word) async {
    try {
      var userStarredWordDoc =
          starredWordsCollection.doc(email).collection('topics').doc(topicId);
      var snapshot = await userStarredWordDoc.get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> words = data['words'] ?? [];

        words.removeWhere((wordInDoc) => wordInDoc['wordId'] == word.wordId);

        await userStarredWordDoc.update({'words': words});
      }

      return const DataSuccess();
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
  Future<DataState<List<WordModel>>> getStarredWords(
      String email, String topicId) async {
    try {
      List<WordModel> starredWords = [];
      var userStarredWordDoc =
          starredWordsCollection.doc(email).collection('topics').doc(topicId);

      var snapshot = await userStarredWordDoc.get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<dynamic> words = data['words'] ?? [];

        starredWords = words.map((word) => WordModel.fromJson(word)).toList();
      }

      return DataSuccess(data: starredWords);
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
  Future<DataState<List<TopicModel>>> getTopicsByTopicName(String name) async {
    try {
      List<TopicModel> topics = [];
      var topicsDoc = await topicCollection.get();

      topics = topicsDoc.docs
          .map((snapshot) => TopicModel.fromJson(snapshot.data()))
          .where((topic) => topic.topicName.toLowerCase().contains(name))
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

  @override
  Future<DataState<void>> addTopicsToFolder(
      String folderId, List<String> topicIds) async {
    try {
      var topics = List.empty(growable: true);
      for (var id in topicIds) {
        var topic = await topicCollection.doc(id).get();

        if (topic.exists) {
          topics.add(topic.data());
        }
      }

      await folderCollection.doc(folderId).update({'topics': topics});

      return const DataSuccess();
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
  Future<DataState<List<FolderModel>>> getFoldersByName(String name) async {
    try {
      List<FolderModel> folders = [];
      var foldersDoc = await folderCollection.get();

      folders = foldersDoc.docs
          .map((snapshot) => FolderModel.fromJson(snapshot.data()))
          .where((folder) => folder.folderName.toLowerCase().contains(name))
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

  @override
  Future<DataState<void>> removeTopicsFromFolder(
      String folderId, List<String> topicIds) async {
    try {
      var topics = List.empty(growable: true);
      for (var id in topicIds) {
        var topic = await topicCollection.doc(id).get();

        if (topic.exists) {
          topics.add(topic.data());
        }
      }

      await folderCollection
          .doc(folderId)
          .update({'topics': FieldValue.arrayRemove(topics)});

      return const DataSuccess();
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
  Future<DataState<void>> removeWordFromTopic(String topicId, String wordId) {
    // TODO: implement removeWordFromTopic
    throw UnimplementedError();
  }
}
