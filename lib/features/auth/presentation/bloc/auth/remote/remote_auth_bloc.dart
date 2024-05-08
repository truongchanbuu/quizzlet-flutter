import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzlet_fluttter/core/resources/data_state.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_event.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthenticationBloc(this._userRepository) : super(AuthenticationState.init()) {
    _userSubscription = _userRepository.user.listen((authUser) {
      add(AuthenticationUserChanged(authUser));
    });
    on<AuthenticationUserChanged>((event, emit) {
      if (event.user != null) {
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        emit(AuthenticationState.unauthenticated(
            message: 'There is no user logged in'));
      }
    });

    on<ReAuthenticateGoogleUser>((event, emit) async {
      try {
        var dataState = await _userRepository.reAuthenticateGoogleUser();
        if (dataState is DataFailed) {
          emit(AuthenticationState.reAuthenticateFailed(
              message: dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(
              AuthenticationState.reAuthenticateSuccess(dataState.data!.user!));
        }
      } catch (e) {
        log(e.toString());
        emit(AuthenticationState.reAuthenticateFailed(message: e.toString()));
      }
    });

    on<ReAuthenticateFacebookUser>((event, emit) async {
      try {
        var dataState = await _userRepository.reAuthenticateFacebookUser();
        if (dataState is DataFailed) {
          emit(AuthenticationState.reAuthenticateFailed(
              message: dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(
              AuthenticationState.reAuthenticateSuccess(dataState.data!.user!));
        }
      } catch (e) {
        log(e.toString());
        emit(AuthenticationState.reAuthenticateFailed(message: e.toString()));
      }
    });

    on<ReAuthenticatePasswordUser>((event, emit) async {
      try {
        var dataState = await _userRepository.reAuthenticatePasswordUser(
            event.email, event.password);

        if (dataState is DataFailed) {
          emit(AuthenticationState.reAuthenticateFailed(
              message: dataState.error?.message ?? 'There is something wrong'));
        } else if (dataState is DataSuccess) {
          emit(
              AuthenticationState.reAuthenticateSuccess(dataState.data!.user!));
        }
      } catch (e) {
        log(e.toString());
        emit(AuthenticationState.reAuthenticateFailed(message: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
