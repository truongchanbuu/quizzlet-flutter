import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizzlet_fluttter/config/theme/app_themes.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/auth/remote/remote_auth_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/reset-password/remote/remote_reset_password_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/bloc/signin/remote/remote_signin_bloc.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/account/signin_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/home_page.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/welcome_page.dart';
import 'package:quizzlet_fluttter/firebase_options.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

import 'features/auth/presentation/pages/account/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializaDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzlet',
      theme: theme(),
      initialRoute: '/',
      routes: {
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
      },
      home: const SafeArea(
        child: WelcomePage(),
      ),
    );
  }
}
