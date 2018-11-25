import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailPage(this.appointment);

  @override
  _AppointmentDetailPageState createState() {
    return _AppointmentDetailPageState();
  }
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  Appointment appointment;
  DateTime measurementStart;

  @override
  void initState() {
    super.initState();
    appointment = widget.appointment;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Appointment details"),
      ),
      body: Column(
        children: <Widget>[
          Text("Description: ${appointment.description}"),
          Text("Creation time: ${appointment.creationTime}"),
          Text("Scheduled start time: ${appointment.scheduledStartTime}"),
          Text("Scheduled end time: ${appointment.scheduledEndTime}"),
          Text("Intervals:"),
          Expanded(
            child: AnimatedOperationsList(
                stream: FirebaseRepository.instance.getIntervalsOfAppointment(appointment.id),
                itemBuilder: _buildIntervalWidget),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: new Icon(measurementStart != null ? Icons.stop : Icons.play_arrow),
          onPressed: () {
            if (measurementStart != null) {
              _finishMeasurement();
            } else {
              _startMeasurement();
            }
          }),
    );
  }

  Widget _buildIntervalWidget(BuildContext context, AppointmentInterval interval, Animation<double> animation,
      int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text("Start: ${interval.startTime}"),
        subtitle: Text("End: ${interval.endTime}"),
      ),
    );
  }

  void _startMeasurement() {
    setState(() {
      measurementStart = DateTime.now();
    });
  }

  void _finishMeasurement() {
    DateTime measurementEnd = DateTime.now();
    AppointmentInterval interval = new AppointmentInterval(measurementStart, measurementEnd);
    FirebaseRepository.instance.addAppointmentInterval(appointment.id, interval).then((unused) {
      setState(() {
        measurementStart = null;
      });
    });
  }
}
