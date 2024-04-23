part of 'remote_signin_bloc.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

final class SignInRequired extends SignInEvent {
  final String email;
  final String password;

  const SignInRequired({required this.email, required this.password});
}

final class SignInWithGoogle extends SignInEvent {
  const SignInWithGoogle();
}

final class SignOutRequired extends SignInEvent {
  const SignOutRequired();
}

