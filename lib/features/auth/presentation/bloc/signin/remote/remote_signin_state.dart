part of 'remote_signin_bloc.dart';

enum SignInStatus { loading, success, failed, signedOut }

class SignInState {
  final SignInStatus status;

  SignInState(this.status);

  factory SignInState.init() {
    return SignInState(SignInStatus.loading);
  }

  factory SignInState.loading() {
    return SignInState(SignInStatus.loading);
  }

  factory SignInState.success() {
    return SignInState(SignInStatus.success);
  }

  factory SignInState.failed() {
    return SignInState(SignInStatus.failed);
  }

  factory SignInState.logOut() {
    return SignInState(SignInStatus.signedOut);
  }
}