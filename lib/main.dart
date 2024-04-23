import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:quizzlet_fluttter/config/theme/app_themes.dart';
import 'package:quizzlet_fluttter/features/auth/domain/repository/user_repository.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/welcome_page.dart';
import 'package:quizzlet_fluttter/firebase_options.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializaDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final userRepo = GetIt.instance.get<UserRepository>();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quizzlet',
      theme: theme(),
      home: SafeArea(
        child: WelcomePage(
          userRepository: userRepo,
        ),
      ),
    );
  }

  // Build UI methods
  _buildAppBar() {
    return AppBar();
  }
}
