import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

part 'remote_update_info_event.dart';
part 'remote_update_info_state.dart';

class UpdateInfoBloc extends Bloc<UpdateInfoEvent, UpdateInfoState> {
  final UserRepository _userRepository;

  UpdateInfoBloc(this._userRepository) : super(UpdateInfoStateInitial()) {
    on<UpdateUserName>((event, emit) async {
      try {
        var dataState = await _userRepository.updateUsername(event.userName);

        if (dataState is DataFailed) {
          emit(UpdateInfoFailed(
              message: dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(const UpdateInfoSuccess());
        }
      } catch (e) {
        log(e.toString());
        emit(UpdateInfoFailed(message: e.toString()));
      }
    });

    on<ReAuthenticateUser>((event, emit) async {
      try {
        var dataState = await _userRepository.reAuthenticate(event.credential);
        if (dataState is DataFailed) {
          emit(UpdateInfoFailed(
              message: dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(const UpdateInfoSuccess());
        }
      } catch (e) {
        log(e.toString());
        emit(UpdateInfoFailed(message: e.toString()));
      }
    });
  }
}
