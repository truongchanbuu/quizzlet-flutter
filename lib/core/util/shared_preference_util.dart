import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

Future<void> saveToSharedPref(String key, String? value) async {
  final storage = GetIt.instance.get<FlutterSecureStorage>();
  await storage.write(key: key, value: value);
}
