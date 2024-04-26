part of 'remote_signup_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SubmitSignUp extends SignUpEvent {
  final UserModel user;

  const SubmitSignUp(this.user);
}

final class ValidatingInput extends SignUpEvent {
  final String email;

  const ValidatingInput(this.email);
}
