import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/remote_signout_event.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/remote_signout_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final UserRepository _userRepository;

  SignOutBloc(this._userRepository) : super(const SignOutInitial()) {
    on<SignOutRequired>((event, emit) async {
      try {
        final dataState = await _userRepository.logOut();

        if (dataState is DataSuccess) {
          emit(const SignOutSuccess());
        } else {
          emit(SignOutFailed(
              message: dataState.error?.message ?? 'There is something wrong'));
        }
      } catch (e) {
        log(e.toString());
        emit(
            SignOutFailed(message: 'There is something wrong ${e.toString()}'));
      }
    });
  }
}
