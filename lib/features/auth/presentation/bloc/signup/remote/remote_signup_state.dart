part of 'remote_signup_bloc.dart';

enum SignUpStatus {
  initial,
  loading,
  success,
  failed,
  emailNotExisted,
  emailExisted,
}

class SignUpState extends Equatable {
  final SignUpStatus status;
  const SignUpState(this.status);

  factory SignUpState.init() {
    return const SignUpState(SignUpStatus.initial);
  }

  factory SignUpState.success() {
    return const SignUpState(SignUpStatus.success);
  }

  factory SignUpState.failed() {
    return const SignUpState(SignUpStatus.failed);
  }

  factory SignUpState.loading() {
    return const SignUpState(SignUpStatus.loading);
  }

  factory SignUpState.emailNotExisted() {
    return const SignUpState(SignUpStatus.emailNotExisted);
  }

  factory SignUpState.emailExisted() {
    return const SignUpState(SignUpStatus.emailExisted);
  }

  @override
  List<Object> get props => [status];
}
