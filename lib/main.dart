import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/uis/common/app_bar.dart';
import 'package:quizzlet_fluttter/uis/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Quizzlet',
      home: SafeArea(
        child: Scaffold(
          appBar: QuizzletAppBar(
            title: '0 / 0',
          ),
          body: HomePage(),
        ),
      ),
    );
  }
}
