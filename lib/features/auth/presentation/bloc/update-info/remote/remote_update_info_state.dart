part of 'remote_update_info_bloc.dart';

sealed class UpdateInfoState extends Equatable {
  const UpdateInfoState();

  @override
  List<Object> get props => [];
}

final class UpdateInfoStateInitial extends UpdateInfoState {}

final class UpdateInfoLoading extends UpdateInfoState {}

final class UpdateInfoFailed extends UpdateInfoState {
  final String message;

  const UpdateInfoFailed({required this.message});
}

final class UpdateInfoSuccess extends UpdateInfoState {
  final dynamic data;

  const UpdateInfoSuccess({this.data});
}
