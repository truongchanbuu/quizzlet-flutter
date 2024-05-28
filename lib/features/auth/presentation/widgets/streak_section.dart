import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizzlet_fluttter/core/util/shared_preference_util.dart';
import 'package:quizzlet_fluttter/features/auth/presentation/widgets/loading_indicator.dart';
import 'package:quizzlet_fluttter/injection_container.dart';

class StreakDaySection extends StatefulWidget {
  const StreakDaySection({super.key});

  @override
  State<StreakDaySection> createState() => _StreakDaySectionState();
}

class _StreakDaySectionState extends State<StreakDaySection> {
  final user = sl.get<FirebaseAuth>().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thành tựu',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        FutureBuilder<int>(
          future: getStreakDate(user.email!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            } else if (snapshot.hasError) {
              debugPrint('Error: ${snapshot.error}');
              return const Center(
                child: Text('Đã có lỗi trong quá trình tải dữ liệu'),
              );
            } else {
              return _buildStreakWidget(context, snapshot.data ?? 0);
            }
          },
        ),
      ],
    );
  }

  Widget _buildStreakWidget(BuildContext context, int streak) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMonthRow(),
            const SizedBox(height: 20),
            _buildStreakRow(streak),
            const SizedBox(height: 25),
            _buildWeekdaysRow(streak),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tháng ${DateTime.now().month}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(width: 10),
        Image.asset(
          'assets/images/calendar.png',
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildStreakRow(int streak) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/fire_streak.png',
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        Text(
          '$streak STREAK',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        const SizedBox(width: 10),
        Image.asset(
          'assets/images/fire_streak.png',
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildWeekdaysRow(streak) {
    final weekDays = getWeekDays();

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      spacing: 20,
      children: weekDays.map((day) {
        var streakDays = _getStreakDays(streak);
        final weekDate = _getWeekdayDay(day);
        final isStreakDay = streakDays.any((streakDay) {
          return int.parse(weekDate) == streakDay.day;
        });

        return _buildDays(day, isStreakDay);
      }).toList(),
    );
  }

  Widget _buildDays(String day, bool isStreakDay) {
    final weekDate = _getWeekdayDay(day);

    return Container(
      decoration: BoxDecoration(
        color: isStreakDay ? Colors.indigo : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: isStreakDay ? const EdgeInsets.all(15) : null,
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: isStreakDay ? Colors.white : null,
              fontWeight: isStreakDay ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            weekDate,
            style: TextStyle(
              color: isStreakDay ? Colors.white : null,
              fontWeight: isStreakDay ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  List<String> getWeekDays() {
    return <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  String _getWeekdayDay(String weekdayName) {
    DateTime now = DateTime.now();
    final todayWeekday = now.weekday;
    final targetWeekday = getWeekDays().indexOf(weekdayName) + 1;
    final distanceDay = targetWeekday - todayWeekday;

    final targetDate = now.add(Duration(days: distanceDay));

    return targetDate.day.toString();
  }

  List<DateTime> _getStreakDays(int streak) {
    final List<DateTime> streakDays = [];
    final now = DateTime.now();

    for (int i = 0; i < streak; i++) {
      streakDays.add(now.subtract(Duration(days: i)));
    }

    return streakDays;
  }
}
