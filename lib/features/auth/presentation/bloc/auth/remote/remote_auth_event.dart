import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationInit extends AuthenticationEvent {
  const AuthenticationInit();
}

final class AuthenticationUserChanged extends AuthenticationEvent {
  final User? user;

  const AuthenticationUserChanged(this.user);
}
