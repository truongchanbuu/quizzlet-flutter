part of 'remote_signup_bloc.dart';

enum SignUpStatus { loading, success, failed }

class SignUpState extends Equatable {
  final SignUpStatus status;

  const SignUpState(this.status);

  factory SignUpState.success() {
    return const SignUpState(SignUpStatus.success);
  }

  factory SignUpState.failed() {
    return const SignUpState(SignUpStatus.failed);
  }

  factory SignUpState.progress() {
    return const SignUpState(SignUpStatus.loading);
  }

  @override
  List<Object> get props => [];
}
