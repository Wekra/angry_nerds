import 'package:flutter/material.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/screens/appointment_detail.dart';

class AppointmentDataListTile extends StatelessWidget {
  final AppointmentData appointment;
  final GestureLongPressCallback onLongPress;

  const AppointmentDataListTile(this.appointment, {this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(appointment.description),
      subtitle: Text("Starts at ${appointment.scheduledStartDateTime.toString()}"),
      trailing: Icon(
        appointment.signatureDateTime != null ? Icons.assignment_turned_in : Icons.check_box_outline_blank),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(appointment.id))),
      onLongPress: onLongPress,
    );
  }
}

class AppointmentIntervalListTile extends StatelessWidget {
  final AppointmentInterval interval;

  const AppointmentIntervalListTile(this.interval);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("Start: ${interval.startDateTime}"),
      subtitle: Text("End: ${interval.endDateTime}"),
    );
  }
}
