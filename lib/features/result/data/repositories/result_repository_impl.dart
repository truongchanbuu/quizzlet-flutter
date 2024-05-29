import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/result/data/models/result.dart';
import 'package:quizzlet_fluttter/features/result/domain/repositories/result_repository.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class ResultRepositoryImp implements ResultRepository {
  final resultCollections = sl.get<FirebaseFirestore>().collection('results');

  @override
  Future<DataState<ResultModel>> getResult(
      String email, String topicId, String examType) async {
    try {
      var docRef =
          resultCollections.doc(topicId).collection(examType).doc(email);
      var snapshot = await docRef.get();
      var data = snapshot.data();

      return DataSuccess(data: ResultModel.fromJson(data!));
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
  Future<DataState<void>> storeResult(
      String email, String topicId, String examType, ResultModel result) async {
    try {
      var docRef =
          resultCollections.doc(topicId).collection(examType).doc(email);
      var snapshot = await docRef.get();

      if (snapshot.exists && snapshot.data() != null) {
        await docRef.update(result.toJson());
      } else {
        docRef.set(result.toJson());
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
  Future<DataState<List<ResultModel>>> getResultsByTopicAndExamType(
      String topicId, String examType) async {
    try {
      List<ResultModel> results = [];

      var examTypeCollection =
          resultCollections.doc(topicId).collection(examType);

      var snapshot = await examTypeCollection.get();

      for (var doc in snapshot.docs) {
        results.add(ResultModel.fromJson(doc.data()));
      }

      return DataSuccess(data: results);
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
}
