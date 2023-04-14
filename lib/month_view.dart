import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'month_info.dart';

class MonthView extends StatelessWidget {
  static const weeksToShow = 6;

  final int year;
  final int month;
  final DateTime? currentDate;
  final DateTime? selectedDate;
  final void Function(DateTime date) onDateSelected;
  final MonthInfo _monthInfo;

  MonthView({
    required this.year,
    required this.month,
    this.currentDate,
    this.selectedDate,
    required this.onDateSelected,
    super.key,
  }) : _monthInfo = DateTime(year, month).monthInfo;

  @override
  Widget build(BuildContext context) {
    final beginningOfFirstMonthWeek = _monthInfo.beginningOfFirstWeek;

    return Table(
      children: [
        TableRow(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black))),
          children: List.generate(
                  DateTime.daysPerWeek,
                  (index) => _weekdayTitle(
                      beginningOfFirstMonthWeek.add(Duration(days: index))))
              .map((day) => _WeekdayTitle(day))
              .toList(),
        ),
        ...List.generate(weeksToShow, (weekIndex) {
          return TableRow(
            children: List.generate(DateTime.daysPerWeek, (dayIndex) {
              final dayOffset = DateTime.daysPerWeek * weekIndex + dayIndex;
              final rowDate =
                  beginningOfFirstMonthWeek.add(Duration(days: dayOffset));
              final isWithinMonth = _monthInfo.contains(rowDate);
              final isCurrentDate = currentDate != null && rowDate.isSameDayAs(currentDate!);

              return _DayView(
                date: rowDate,
                isWithinMonth: isWithinMonth,
                isCurrentDay: isCurrentDate,
                isSelected: selectedDate != null && rowDate.isSameDayAs(selectedDate!),
                onTap: () {
                  if (!isWithinMonth) {
                    return;
                  }
                  onDateSelected(rowDate);
                },
              );
            }),
          );
        })
      ],
    );
  }

  static String _weekdayTitle(DateTime date) => DateFormat("ccccc").format(date);
}

class _DayView extends StatelessWidget {
  final DateTime date;
  final bool isWithinMonth;
  final bool isCurrentDay;
  final bool isSelected;
  final void Function()? onTap;

  const _DayView({
    required this.date,
    required this.isWithinMonth,
    required this.isCurrentDay,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(Object context) {
    final Color color;
    if (isCurrentDay && isSelected) {
      color = Colors.white;
    } else if (isSelected) {
      color = Colors.deepOrange;
    } else if (isWithinMonth) {
      color = Colors.black;
    } else {
      color = Colors.grey;
    }

    final child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        decoration: isCurrentDay
            ? BoxDecoration(
                color: isSelected ? Colors.deepOrange : null,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.deepOrange,
                  width: 1.5,
                ),
              )
            : null,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat.d().format(date),
            style: TextStyle(
              fontWeight: isWithinMonth ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ),
      ),
    );

    if (!isWithinMonth) {
      return ExcludeSemantics(
        child: child,
      );
    }

    return Semantics(
      button: true,
      label: DateFormat.yMMMd().format(date),
      selected: isSelected,
      child: child,
    );
  }
}

class _WeekdayTitle extends StatelessWidget {
  final String text;

  const _WeekdayTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
