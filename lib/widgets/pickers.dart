import 'package:flutter/material.dart';

DateTime earliestDate = DateTime(2000);
DateTime latestDate = DateTime(2100);

/// First shows a date picker, then shows a time picker and finally returns the combined [DateTime].
Future<DateTime> showDateAndTimePicker(BuildContext context) {
  return showDatePicker(context: context, initialDate: DateTime.now(), firstDate: earliestDate, lastDate: latestDate)
      .then((DateTime date) => showTimePickerForDate(context, date));
}

Future<DateTime> showTimePickerForDate(BuildContext context, DateTime date) {
  return showTimePicker(context: context, initialTime: TimeOfDay.now())
      .then((TimeOfDay time) => DateTime(date.year, date.month, date.day, time.hour, time.minute));
}
