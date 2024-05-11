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

final class UpdatePassword extends UpdateInfoEvent {
  final String password;

  const UpdatePassword(this.password);
}

final class UpdateProfileAvatar extends UpdateInfoEvent {
  final String photoURL;

  const UpdateProfileAvatar(this.photoURL);
}

final class UploadAvatar extends UpdateInfoEvent {
  final String emailAsID;
  final String imgPath;

  const UploadAvatar(this.emailAsID, this.imgPath);
}
