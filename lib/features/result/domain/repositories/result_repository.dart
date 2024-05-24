import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/result/data/models/result.dart';

abstract class ResultRepository {
  Future<DataState<ResultModel>> getResult(String email, String topicId);
  Future<DataState<void>> storeResult(
      String email, String topicId, String examType, ResultModel result);
  Future<DataState<List<ResultModel>>> getResultsByTopic(String topicId);
}
