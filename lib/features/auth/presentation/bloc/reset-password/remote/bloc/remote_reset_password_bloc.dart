import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';

part 'remote_reset_password_event.dart';
part 'remote_reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final UserRepository _userRepository;

  ResetPasswordBloc(this._userRepository) : super(ResetPasswordState.processing()) {
    on<ResetPasswordRequired>((event, emit) async {
      try {
        await _userRepository.resetPassword(event.email);
      } catch (e) {
        log(e.toString());
      }
    });
  }
}
