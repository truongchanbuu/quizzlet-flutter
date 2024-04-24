import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/config/theme/app_themes.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final userRepository = sl.get<UserRepository>();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzlet',
      theme: theme(),
      routes: {
        '/account/sign-up': (context) => SignUpPage(
              userRepository: userRepository,
            ),
      },
      home: SafeArea(
        child: WelcomePage(
          userRepository: userRepository,
        ),
      ),
    );
  }
}
