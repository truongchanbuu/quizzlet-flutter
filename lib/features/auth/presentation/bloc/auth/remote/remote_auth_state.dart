import 'package:firebase_auth/firebase_auth.dart';

enum AuthenticationStatus { authenticated, unauthenticated, unknown }

class AuthenticationState {
  final AuthenticationStatus status;
  final User? user;

  AuthenticationState({required this.status, this.user});

  factory AuthenticationState.init() {
    return AuthenticationState(status: AuthenticationStatus.unknown);
  }

  factory AuthenticationState.authenticated(User user) {
    return AuthenticationState(
        status: AuthenticationStatus.authenticated, user: user);
  }

  factory AuthenticationState.unauthenticated() {
    return AuthenticationState(status: AuthenticationStatus.unauthenticated);
  }
}
