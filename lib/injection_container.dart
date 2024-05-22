import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizzlet_fluttter/features/auth/data/data_source/remote/user_api_service.dart';
import 'package:quizzlet_fluttter/features/auth/data/repository/user_repository_impl.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/reset-password/remote/remote_reset_password_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signin/remote/remote_signin_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signout/remote/remote_signout_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signup/remote/remote_signup_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/update-info/remote/remote_update_info_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/data/repository/topic_repository_impl.dart';
import 'package:quizzlet_fluttter/features/topic/domain/repository/topic_repository.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/folder/remote/folder_bloc.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/bloc/topic/remote/topic_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

final sl = GetIt.instance;

Future<void> initializaDependencies() async {
  // Dio
  sl.registerSingleton<Dio>(Dio());

  // API
  sl.registerSingleton<UserApiService>(UserApiService(sl()));

  // Firebase
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  sl.registerSingleton<FirebaseStorage>(FirebaseStorage.instance);
  sl.registerSingleton<GoogleSignIn>(GoogleSignIn(
    clientId:
        '636054365584-m1b19monh4bnrn297nsnpt94kepo1srq.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  ));

  AndroidOptions getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);
  sl.registerSingleton<FlutterSecureStorage>(
      FlutterSecureStorage(aOptions: getAndroidOptions()));

  // Facebook Auth Instance
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "1790488901429891",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }

  sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl(), sl()));
  sl.registerSingleton<TopicRepository>(TopicRepositoryImpl());

  // Text-2-Speech
  sl.registerSingleton<FlutterTts>(FlutterTts());

  // Blocs
  sl.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(sl()));
  sl.registerFactory<SignInBloc>(() => SignInBloc(sl()));
  sl.registerFactory<SignUpBloc>(() => SignUpBloc(sl()));
  sl.registerFactory<SignOutBloc>(() => SignOutBloc(sl()));
  sl.registerFactory<UpdateInfoBloc>(() => UpdateInfoBloc(sl()));
  sl.registerFactory<ResetPasswordBloc>(() => ResetPasswordBloc(sl()));

  sl.registerFactory<TopicBloc>(() => TopicBloc(sl()));
  sl.registerFactory<FolderBloc>(() => FolderBloc(sl()));
}
