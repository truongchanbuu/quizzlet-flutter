import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
          emit(UpdateInfoSuccess(data: dataState.data));
        }
      } catch (e) {
        log(e.toString());
        emit(UpdateInfoFailed(message: e.toString()));
      }
    });

    on<UpdateEmail>((event, emit) async {
      try {
        var dataState = await _userRepository.updateEmail(event.email);

        if (dataState is DataFailed) {
          emit(UpdateInfoFailed(
              message: dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(UpdateInfoSuccess(data: dataState.data));
        }
      } catch (e) {
        log(e.toString());
        emit(UpdateInfoFailed(message: e.toString()));
      }
    });
  }
}
