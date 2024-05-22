import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

part 'remote_signin_event.dart';
part 'remote_signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc(this._userRepository) : super(SignInState.init()) {
    on<SignInRequired>((event, emit) async {
      try {
        final dataState =
            await _userRepository.signIn(event.email, event.password);
        if (dataState is DataSuccess) {
          String? token = await dataState.data!.user!.getIdToken();
          emit(SignInState.success(token!));
        } else if (dataState is DataFailed &&
            dataState.error!.error == 'wrong-password') {
          emit(SignInState.wrongPassword());
        } else if (dataState is DataFailed &&
            dataState.error!.error == 'user-not-found') {
          emit(SignInState.emailNotFound());
        } else if (dataState is DataFailed &&
            dataState.error!.error == 'user-disabled') {
          emit(SignInState.disabled());
        } else {
          emit(SignInState.failed(dataState.error?.message ??
              'Please check your email and password again'));
        }
      } catch (e) {
        log(e.toString());
        emit(SignInState.failed('There is something wrong: ${e.toString()}'));
      }
    });

    on<SignInWithGoogle>((event, emit) async {
      try {
        final dataState = await _userRepository.signInWithGoogle();
        if (dataState is DataSuccess && dataState.data != null) {
          String? token = await dataState.data!.user!.getIdToken();
          emit(SignInState.success(token!));
        } else {
          emit(SignInState.failed(
              dataState.error?.message ?? 'There is something wrong'));
        }
      } catch (e) {
        log('Google login failed: ${e.toString()}');
        emit(SignInState.failed('There is something wrong: ${e.toString()}'));
      }
    });

    on<SignInWithFacebook>((event, emit) async {
      try {
        final dataState = await _userRepository.signInWithFacebook();
        if (dataState is DataSuccess) {
          String? token = await dataState.data!.user!.getIdToken();
          emit(SignInState.success(token!));
        } else {
          emit(SignInState.failed(
              dataState.error?.message ?? 'There is something wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(SignInState.failed('There is something wrong: ${e.toString()}'));
      }
    });
  }
}
