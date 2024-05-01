part of 'remote_signin_bloc.dart';

enum SignInStatus { loading, success, failed, signedOut }

class SignInState {
  final SignInStatus status;
  final String? token;

  SignInState(this.status, {this.token});

  factory SignInState.init() {
    return SignInState(SignInStatus.loading);
  }

  factory SignInState.loading() {
    return SignInState(SignInStatus.loading);
  }

  factory SignInState.success(String token) {
    return SignInState(SignInStatus.success, token: token);
  }

  factory SignInState.failed() {
    return SignInState(SignInStatus.failed);
  }

  factory SignInState.logOut() {
    return SignInState(SignInStatus.signedOut);
  }
}
