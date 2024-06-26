import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme(),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    color: Colors.white,
    elevation: 1,
    shadowColor: Colors.grey,
    centerTitle: false,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );
}
