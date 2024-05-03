import 'package:flutter/material.dart';

class StreakDaySection extends StatelessWidget {
  final int streakDays;
  final DateTime? initialStreakDay;
  const StreakDaySection({
    super.key,
    required this.streakDays,
    this.initialStreakDay,
  });

  List<String> getWeekDays() {
    return <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  String _getWeekdayDate(String weekdayName) {
    DateTime now = DateTime.now();
    int todayWeekday = now.weekday;
    int targetWeekday = getWeekDays().indexOf(weekdayName) + 1;
    int daysToAdd = ((targetWeekday - todayWeekday) + 7) % 7;

    DateTime targetDate = now.subtract(Duration(days: daysToAdd));

    return targetDate.day.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thành tựu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tháng ${DateTime.now().month.toString()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        // color: Colors.white,
                        letterSpacing: double.minPositive,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      '/images/calendar.png',
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      '/images/fire_streak.png',
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${streakDays.toString()} STREAK',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      '/images/fire_streak.png',
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: getWeekDays().map(_buildDays).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDays(String day) {
    String weekDate = _getWeekdayDate(day);
    bool isToday = DateTime.now().day.toString() == weekDate;

    return Container(
      decoration: BoxDecoration(
        color: isToday ? Colors.indigo : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: isToday ? const EdgeInsets.all(15) : null,
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: isToday ? Colors.white : null,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            weekDate,
            style: TextStyle(
              color: isToday ? Colors.white : null,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
