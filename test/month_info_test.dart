import 'package:calendar/month_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("First day of week of month", () {
    final monthsAndFirstWeekDate = {
      DateTime(2022, 01).monthInfo: DateTime(2021, 12, 27),
      DateTime(2022, 05).monthInfo: DateTime(2022, 04, 25),
      DateTime(2022, 08).monthInfo: DateTime(2022, 08, 01),
    };

    monthsAndFirstWeekDate.forEach((month, firstWeekDate) {
      test("${month.start.month} ${month.start.year} is $firstWeekDate", () {
        expect(month.beginningOfFirstWeek, equals(firstWeekDate));
      });
    });
  });

  group("Month contains day", () {
    final monthAndDay = {
      DateTime(2022, 01).monthInfo: DateTime(2022, 01, 01),
      DateTime(2022, 07).monthInfo: DateTime(2022, 07, 31),
      DateTime(2023, 04).monthInfo: DateTime(2023, 04, 08),
    };

    monthAndDay.forEach((month, date) {
      test("${month.start.month}/${month.start.year} contains ${date.day}/${date.month}/${date.year}", () {
        expect(month.contains(date), isTrue);
      });
    });
  });

  group("Month does not contain day", () {
    final monthAndDay = {
      DateTime(2022, 01).monthInfo: DateTime(2022, 02, 01),
      DateTime(2022, 07).monthInfo: DateTime(2022, 06, 30),
      DateTime(2023, 04).monthInfo: DateTime(2024, 04, 08),
    };

    monthAndDay.forEach((month, date) {
      test("${month.start.month}/${month.start.year} does not contain ${date.day}/${date.month}/${date.year}", () {
        expect(month.contains(date), isFalse);
      });
    });
  });
}
