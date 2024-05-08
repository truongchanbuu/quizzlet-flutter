part of 'remote_update_info_bloc.dart';

sealed class UpdateInfoEvent extends Equatable {
  const UpdateInfoEvent();

  @override
  List<Object> get props => [];
}

final class UpdateUserName extends UpdateInfoEvent {
  final String userName;

  const UpdateUserName(this.userName);
}

final class UpdateEmail extends UpdateInfoEvent {
  final String email;

  const UpdateEmail(this.email);
}
