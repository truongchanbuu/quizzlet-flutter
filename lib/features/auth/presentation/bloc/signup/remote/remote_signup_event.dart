part of 'remote_signup_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpRequired extends SignUpEvent {
  final UserModel user;
  
  const SignUpRequired(this.user);
}
