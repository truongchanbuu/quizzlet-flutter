import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

part 'remote_signin_event.dart';
part 'remote_signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(
    this._userRepository
  ) : super(SignInState.init()) {
    on<SignInRequired>((event, emit) async {
      try {
        await _userRepository.signIn(event.email, event.password);
        emit(SignInState.success());
      } catch (e) {
        log(e.toString());
        emit(SignInState.failed());
      }
    });

    on<SignInWithGoogle>((event, emit) async {
      try {
        await _userRepository.signInWithGoogle();
        emit(SignInState.success());
      } catch (e) {
        log(e.toString());
        emit(SignInState.failed());
      }
    });

    on<SignOutRequired>((event, emit) async {
      try {
        await _userRepository.logOut();
        emit(SignInState.logOut());
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
