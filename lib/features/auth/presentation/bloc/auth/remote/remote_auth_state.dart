import 'package:firebase_auth/firebase_auth.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  unknown,
  reAuthSuccess,
  reAuthFailed,
}

class AuthenticationState {
  final AuthenticationStatus status;
  final User? user;
  final String? message;

  AuthenticationState({required this.status, this.user, this.message});

  factory AuthenticationState.init() {
    return AuthenticationState(status: AuthenticationStatus.unknown);
  }

  factory AuthenticationState.authenticated(User user) {
    return AuthenticationState(
        status: AuthenticationStatus.authenticated, user: user);
  }

  factory AuthenticationState.unauthenticated({String? message}) {
    return AuthenticationState(
        status: AuthenticationStatus.unauthenticated, message: message);
  }

  factory AuthenticationState.reAuthenticateFailed({String? message}) {
    return AuthenticationState(
        status: AuthenticationStatus.reAuthFailed, message: message);
  }

  factory AuthenticationState.reAuthenticateSuccess(User user,
      {String? message}) {
    return AuthenticationState(
        status: AuthenticationStatus.reAuthSuccess,
        message: message,
        user: user);
  }
}
