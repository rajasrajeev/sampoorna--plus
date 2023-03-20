// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/single_day_attendance/single_day_attendance.dart';
import 'package:student_management/services/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class AttendanceListCalender extends StatefulWidget {
  final String batchId;
  final String schoolId;
  const AttendanceListCalender(
      {required this.batchId, required this.schoolId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AttendanceListCalenderState createState() => _AttendanceListCalenderState();
}

class _AttendanceListCalenderState extends State<AttendanceListCalender> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // print("====================> $kEvents");
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      final String formatted = formatter.format(_selectedDay!);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SingleDayAttendanceScreen(
                  date: formatted,
                  batchId: widget.batchId,
                  schoolId: widget.schoolId,
                )),
      );
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Event>(
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: _rangeStart,
        rangeEndDay: _rangeEnd,
        rowHeight: 75,
        calendarFormat: _calendarFormat,
        rangeSelectionMode: _rangeSelectionMode,
        eventLoader: _getEventsForDay,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekendStyle: const TextStyle().copyWith(color: primaryColor),
        ),
        enabledDayPredicate: (date) {
          return date.weekday == DateTime.monday ||
              date.weekday == DateTime.tuesday ||
              date.weekday == DateTime.wednesday ||
              date.weekday == DateTime.thursday ||
              date.weekday == DateTime.friday;
        },
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        calendarStyle: const CalendarStyle(
          // Use `CalendarStyle` to customize the UI
          outsideDaysVisible: false,
          isTodayHighlighted: true,
          tableBorder:
              TableBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          cellMargin: EdgeInsets.all(9),
          todayDecoration: BoxDecoration(
            color: secondaryColor,
            shape: BoxShape.rectangle,
          ),
          selectedDecoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.rectangle,
          ),
        ),
        onDaySelected: _onDaySelected,
        onRangeSelected: _onRangeSelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          final String formatted = formatter.format(focusedDay);
          int lastday = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
          print(
              "$formatted - ${focusedDay.year}-${focusedDay.month}-${lastday}");
          _focusedDay = focusedDay;
        },
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: const TextStyle(color: Colors.white),
              )),
          markerBuilder: (context, day, events) => events.isNotEmpty
              ? Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(112, 92, 92, 92),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Text(
                    '${events.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : null,
          todayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: const TextStyle(color: Colors.white),
              )),
        ));
  }
}
