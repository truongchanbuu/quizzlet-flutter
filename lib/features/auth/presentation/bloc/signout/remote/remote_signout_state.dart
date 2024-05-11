import 'package:equatable/equatable.dart';

sealed class SignOutState extends Equatable {
  const SignOutState();

  @override
  List<Object> get props => [];
}

final class SignOutInitial extends SignOutState {
  const SignOutInitial();
}

final class SignOutLoading extends SignOutState {
  const SignOutLoading();
}

final class SignOutFailed extends SignOutState {
  final String message;
  const SignOutFailed({required this.message});
}

final class SignOutSuccess extends SignOutState {
  const SignOutSuccess();
}
