import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/config/routes/app_routes.dart';
import 'package:quizzlet_fluttter/config/theme/app_themes.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/pages/home/welcome_page.dart';
import 'package:quizzlet_fluttter/firebase_options.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDependencies();
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
      routes: routes(),
      home: const SafeArea(
        child: WelcomePage(),
      ),
    );
  }
}
