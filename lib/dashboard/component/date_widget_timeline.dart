library date_picker_timeline;

import 'package:flutter/material.dart';
import 'date_widget.dart';
import '../component/color.dart';
import '../component/dimen.dart';
import '../component/tap.dart';

class DatePickerTimeline extends StatefulWidget {
  final double dateSize, daySize, monthSize;
  final Color dateColor, monthColor, dayColor;
  DateTime currentDate;
  final DateChangeListener onDateChange;

  DatePickerTimeline(
    this.currentDate, {
    Key? key,
    this.dateSize = Dimen.dateTextSize,
    this.daySize = Dimen.dayTextSize,
    this.monthSize = Dimen.monthTextSize,
    this.dateColor = const Color(0XFF346751),
    this.monthColor = const Color(0XFF346751),
    this.dayColor = const Color(0XFF346751),
    required this.onDateChange,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _DatePickerState();
}

class _DatePickerState extends State<DatePickerTimeline> {
  @override
  void initState() {
    DateTime _date = DateTime.now();
    widget.currentDate = new DateTime(_date.year, _date.month, _date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        child: ListView.builder(
            itemCount: 100,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              DateTime _date = DateTime.now()
                  .subtract(Duration(days: 4))
                  .add(Duration(days: index));
              DateTime date = new DateTime(_date.year, _date.month, _date.day);
              bool isSelected = compareDate(date, widget.currentDate);

              return DateWidget(
                  date: date,
                  dateColor: isSelected ? Colors.white : Color(0XFF346751),
                  dateSize: widget.dateSize,
                  dayColor: isSelected ? Colors.white : Color(0XFF346751),
                  daySize: widget.daySize,
                  monthColor: isSelected ? Colors.white : Color(0XFF346751),
                  monthSize: widget.monthSize,
                  selectionColor: isSelected
                      ? Color(0XFF346751)
                      : Color.fromARGB(71, 75, 75, 75),
                  onDateSelected: (selectedDate) {
                    // A date is selected
                    if (widget.onDateChange != null) {
                      widget.onDateChange(selectedDate);
                    }
                    setState(() {
                      widget.currentDate = selectedDate;
                    });
                  });
            }));
  }

  bool compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}
