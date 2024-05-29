import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quizzlet_fluttter/core/util/date_time_util.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

final storage = sl.get<FlutterSecureStorage>();
String streakDayKey = 'streak_day';
String lastLoginDateKey = 'last_login';

String getStreakDayKey(String email) {
  return '$email-$streakDayKey';
}

Future<void> saveToSharedPref(String key, String? value) async {
  await storage.write(key: key, value: value);
}

Future<void> deleteToken() async {
  final storage = sl.get<FlutterSecureStorage>();
  await storage.delete(key: 'token');
}

Future<int> getStreakDate(String email) async {
  String key = getStreakDayKey(email);
  return int.parse(await storage.read(key: key) ?? '10');
}

Future<void> startStreakDay() async {
  await storage.write(key: streakDayKey, value: '0');
}

Future<void> addStreakDay(String email) async {
  var streakDay = await getStreakDate(email);
  String key = getStreakDayKey(email);
  await storage.write(key: key, value: (streakDay + 1).toString());
}

Future<void> setLastLogin() async {
  await storage.write(key: lastLoginDateKey, value: DateTime.now().toString());
}

Future<void> updateStreakDay(String email) async {
  var lastLogin =
      DateTime.tryParse(await storage.read(key: lastLoginDateKey) ?? '');

  if (lastLogin != null) {
    if (isYesterday(lastLogin)) {
      addStreakDay(email);
    } else if (!isToday(lastLogin)) {
      startStreakDay();
    }
  } else {
    startStreakDay();
  }

  await setLastLogin();
}
