part of 'result_bloc.dart';

sealed class ResultState extends Equatable {
  const ResultState();

  @override
  List<Object> get props => [];
}

final class ResultInitial extends ResultState {}

final class ResultStored extends ResultState {}

final class ResultStoreFailed extends ResultState {}

final class ResultStoring extends ResultState {}

final class GetUserResultSuccess extends ResultState {}

final class GetUserResultFailed extends ResultState {}

final class GettingUserResult extends ResultState {}

final class GetAllResultsByTopicSuccess extends ResultState {}

final class GetAllResultsByTopicFailed extends ResultState {}

final class GettingAllResultsByTopic extends ResultState {}
