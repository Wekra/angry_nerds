import 'package:flutter/material.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/screens/appointment_detail.dart';

class AppointmentDataListTile extends StatelessWidget {
  final AppointmentData appointment;
  final GestureLongPressCallback onLongPress;

  const AppointmentDataListTile({@required this.appointment, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(appointment.description),
      subtitle: Text("Starts at ${appointment.scheduledStartDateTime.toString()}"),
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(appointment.id))),
      onLongPress: onLongPress,
    );
  }
}
