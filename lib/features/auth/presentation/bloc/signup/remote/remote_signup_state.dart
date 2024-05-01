part of 'remote_signup_bloc.dart';

enum SignUpStatus {
  loading,
  progressing,
  success,
  failed,
  emailNotExisted,
  emailExisted,
}

class SignUpState extends Equatable {
  final SignUpStatus status;
  const SignUpState(this.status);

  factory SignUpState.init() {
    return const SignUpState(SignUpStatus.loading);
  }

  factory SignUpState.success() {
    return const SignUpState(SignUpStatus.success);
  }

  factory SignUpState.failed() {
    return const SignUpState(SignUpStatus.failed);
  }

  factory SignUpState.validating() {
    return const SignUpState(SignUpStatus.progressing);
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
