part of 'remote_signup_bloc.dart';

enum SignUpStatus {
  loading,
  progressing,
  success,
  failed,
  validated,
  unvalidated,
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

  factory SignUpState.validated() {
    return const SignUpState(SignUpStatus.validated);
  }

  factory SignUpState.unvalidated() {
    return const SignUpState(SignUpStatus.unvalidated);
  }

  @override
  List<Object> get props => [];
}
