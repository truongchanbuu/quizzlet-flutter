import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/features/auth/data/data_source/remote/user_api_service.dart';
import 'package:quizzlet_fluttter/features/auth/data/repository/user_repository_impl.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/reset-password/remote/bloc/remote_reset_password_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signin/remote/remote_signin_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signup/remote/remote_signup_bloc.dart';

final sl = GetIt.instance;

Future<void> initializaDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // API
  sl.registerSingleton<UserApiService>(UserApiService(sl()));

  // Firebase
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl()));

  // Blocs
  sl.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(sl()));
  sl.registerFactory<SignInBloc>(() => SignInBloc(sl()));
  sl.registerFactory<SignUpBloc>(() => SignUpBloc(sl()));
  sl.registerFactory<ResetPasswordBloc>(() => ResetPasswordBloc(sl()));
}
