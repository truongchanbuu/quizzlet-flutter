part of 'result_bloc.dart';

sealed class ResultEvent extends Equatable {
  const ResultEvent();

  @override
  List<Object> get props => [];
}

final class StoreResult extends ResultEvent {
  final String topicId;
  final String examType;
  final ResultModel result;
  final String email;

  const StoreResult({
    required this.result,
    required this.examType,
    required this.topicId,
    required this.email,
  });
}

final class GetUserResultByTopic extends ResultEvent {
  final String email;
  final String topicId;

  const GetUserResultByTopic(this.email, this.topicId);
}

final class GetAllResultsByTopic extends ResultEvent {
  final String topicId;

  const GetAllResultsByTopic(this.topicId);
}
