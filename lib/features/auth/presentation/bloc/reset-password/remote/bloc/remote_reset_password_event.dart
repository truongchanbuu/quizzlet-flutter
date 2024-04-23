part of 'remote_reset_password_bloc.dart';

sealed class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object> get props => [];
}

final class ResetPasswordRequired extends ResetPasswordEvent {
  final String email;

  const ResetPasswordRequired(this.email);
}
