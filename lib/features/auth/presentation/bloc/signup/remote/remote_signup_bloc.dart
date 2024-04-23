import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

part 'remote_signup_event.dart';
part 'remote_signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpState.progress()) {
    on<SignUpRequired>((event, emit) async {
      try {
        UserModel? user = (await _userRepository.signUp(event.user)).data;
        await _userRepository.setUserData(user ?? event.user);
        emit(SignUpState.success());
      } catch (e) {
        log(e.toString());
        emit(SignUpState.failed());
      }
    });
  }
}
