import 'package:equatable/equatable.dart';

sealed class SignOutEvent extends Equatable {
  const SignOutEvent();
  @override
  List<Object> get props => [];
}

final class SignOutRequired extends SignOutEvent {}
