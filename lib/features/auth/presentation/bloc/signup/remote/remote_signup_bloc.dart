import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/data/models/user.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

part 'remote_signup_event.dart';
part 'remote_signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpState.init()) {
    on<SubmitSignUp>((event, emit) async {
      try {
        emit(SignUpState.loading());
        var dataState = await _userRepository.signUp(event.user);

        if (dataState is DataFailed &&
            dataState.error!.error == 'email-already-in-use') {
          emit(SignUpState.emailExisted());
        } else if (dataState is DataFailed) {
          emit(SignUpState.failed());
        } else if (dataState is DataSuccess && dataState.data != null) {
          UserModel? user = dataState.data!.copyWith(
            password:
                DBCrypt().hashpw(dataState.data!.password, DBCrypt().gensalt()),
          );

          await _userRepository.setUserData(user);
          emit(SignUpState.success());
        }
      } catch (e) {
        log(e.toString());
        emit(SignUpState.failed());
      }
    });
  }
}
