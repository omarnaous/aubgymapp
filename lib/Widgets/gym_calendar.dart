// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:aub_gymsystem/constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class GymCalendar extends StatefulWidget {
  const GymCalendar({
    Key? key,
    required this.selectedDate,
    required this.onSelection,
  }) : super(key: key);
  final DateTime selectedDate;
  final Function(DateTime) onSelection;

  @override
  State<GymCalendar> createState() => _GymCalendarState();
}

class _GymCalendarState extends State<GymCalendar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 3, 14),
        calendarStyle: CalendarStyle(
          todayTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          todayDecoration: BoxDecoration(
              color: ConstantsClass.themeColor, shape: BoxShape.circle),
          selectedDecoration: BoxDecoration(color: ConstantsClass.themeColor),
          markerDecoration: BoxDecoration(
            color: ConstantsClass.themeColor,
          ),
        ),
        focusedDay: widget.selectedDate,
        currentDay: widget.selectedDate,
        onDaySelected: (time1, time2) {
          widget.onSelection(time2);
        },
      ),
    );
  }
}
