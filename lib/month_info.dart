class MonthInfo {
  final DateTime start;

  MonthInfo(int year, int month) : start = DateTime(year, month);
  MonthInfo.of(DateTime date) : this(date.year, date.month);

  DateTime get beginningOfFirstWeek {
    final firstMonthDayOffsetIntoWeek = start.weekday - 1;
    return DateTime(start.year, start.month, start.day - firstMonthDayOffsetIntoWeek);
  }

  bool contains(DateTime date) => date.year == start.year && date.month == start.month;
}

extension MonthInfoExt on DateTime {
  MonthInfo get monthInfo => MonthInfo.of(this);

  bool isSameDayAs(DateTime other) => year == other.year && month == other.month && day == other.day;
}
