import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        emit(AuthenticationState.unauthenticated());
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
