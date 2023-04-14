import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'month_view.dart';

class Calendar extends StatefulWidget {
  final DateTime currentDate;
  final int earliestYear;

  const Calendar(
      {super.key, required this.currentDate, this.earliestYear = 2000});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _selectedDay;
  late PageController _pageController;

  @override
  void initState() {
    _selectedDay = widget.currentDate;
    _pageController = PageController(initialPage: _indexOfCurrentMonth);
    super.initState();
  }

  int get _indexOfCurrentMonth {
    // Calculate page based on the earliest months the user can scroll back to, which should be January 2000
    final yearsSinceEarliestYear =
        widget.currentDate.year - widget.earliestYear;
    return yearsSinceEarliestYear * DateTime.monthsPerYear +
        widget.currentDate.month;
  }

  void _goToToday() {
    _pageController.animateToPage(
      _indexOfCurrentMonth,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
    setState(() {
      _selectedDay = widget.currentDate;
    });
  }

  void _goToPreviousMonth() {
    final currentPage =
        _pageController.page?.round() ?? _pageController.initialPage;
    _pageController.animateToPage(
      currentPage - 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  void _goToNextMonth() {
    final currentPage =
        _pageController.page?.round() ?? _pageController.initialPage;
    _pageController.animateToPage(
      currentPage + 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kalender"),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PageView.builder(
            controller: _pageController,
            itemBuilder: (context, monthIndex) {
              final year = widget.earliestYear +
                  (monthIndex / DateTime.monthsPerYear).floor();
              final month = monthIndex % DateTime.monthsPerYear;

              return Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: _goToPreviousMonth,
                          icon: const Icon(Icons.arrow_left)),
                      Expanded(
                        child: Text(
                          DateFormat.yMMMM().format(DateTime(year, month)),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      IconButton(
                          onPressed: _goToNextMonth,
                          icon: const Icon(Icons.arrow_right)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  MonthView(
                    year: year,
                    month: month,
                    currentDate: widget.currentDate,
                    selectedDate: _selectedDay,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDay = date;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
