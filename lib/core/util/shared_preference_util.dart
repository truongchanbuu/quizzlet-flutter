import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

Future<void> saveToSharedPref(String key, String? value) async {
  final storage = sl.get<FlutterSecureStorage>();
  await storage.write(key: key, value: value);
}

Future<void> deleteToken() async {
  final storage = sl.get<FlutterSecureStorage>();
  await storage.delete(key: 'token');
}
