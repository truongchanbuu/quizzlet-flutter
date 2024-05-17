import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/reset-password/remote/remote_reset_password_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signin/remote/remote_signin_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/signin_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/signup_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/home_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/create_topic_page.dart';
import 'package:quizzlet_fluttter/features/topic/presentation/pages/topic/topic_setting_page.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

Map<String, Widget Function(BuildContext context)> routes() {
  return {
    '/home': (context) => const HomePage(),
    '/account/sign-up': (context) => const SignUpPage(),
    '/account/sign-in': (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl.get<AuthenticationBloc>(),
            ),
            BlocProvider(
              create: (context) => sl.get<SignInBloc>(),
            ),
            BlocProvider(
              create: (context) => sl.get<ResetPasswordBloc>(),
            )
          ],
          child: const SignInPage(),
        ),
    '/topic/create': (context) => const CreateTopicPage(),
    'topic/create/setting': (context) => const TopicSettingPage(),
  };
}
