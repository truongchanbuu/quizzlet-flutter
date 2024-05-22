DateTime now = DateTime.now();

DateTime firstDateOfTheWeek(DateTime date) {
  return date.subtract(Duration(days: date.weekday - 1));
}

DateTime lastDateOfTheWeek(DateTime date) {
  return date.add(Duration(days: DateTime.daysPerWeek - date.weekday));
}

bool isToday(DateTime date) {
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

bool isTheSameDate(DateTime d1, DateTime d2) {
  return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}

bool isYesterday(DateTime date) {
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day - 1;
}

bool isThisWeek(DateTime date) {
  DateTime firstDate = firstDateOfTheWeek(now);
  DateTime lastDate = lastDateOfTheWeek(now);

  return (isTheSameDate(date, firstDate) || date.isAfter(firstDate)) &&
      (isTheSameDate(date, lastDate) || date.isBefore(lastDate));
}

bool isLastWeek(DateTime date) {
  DateTime firstDate =
      firstDateOfTheWeek(now.subtract(const Duration(days: 7)));
  DateTime lastDate = lastDateOfTheWeek(now.subtract(const Duration(days: 7)));

  return (isTheSameDate(date, firstDate) || date.isAfter(firstDate)) &&
      (isTheSameDate(date, lastDate) || date.isBefore(lastDate));
}

bool isLastMonth(DateTime date) {
  return date.year == now.year && date.month == now.month - 1;
}
