import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/appointment.dart';
import 'package:service_app/screens/appointment_detail.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class AppointmentListPage extends DrawerPage {
  @override
  _AppointmentListPageState createState() {
    return _AppointmentListPageState();
  }

  @override
  String get title => "Appointments";

  @override
  IconData get icon => Icons.calendar_today;
}

class _AppointmentListPageState extends State<AppointmentListPage> {
  @override
  Widget build(BuildContext context) {
    debugPrint("Building AppointmentListPage state");
    return new Scaffold(
      body: AnimatedOperationsList(
          stream: FirebaseRepository.instance.getAppointmentsOfTechnician(), itemBuilder: _buildListItem),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(null))),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Appointment appointment, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
          title: Text(appointment.description),
          subtitle: Text(
              "Starts at ${appointment.scheduledStartDateTime.toString()}, has ${appointment.intervals
                  .length} intervals"),
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailPage(appointment))),
        onLongPress: () => _showDeleteDialog(context, appointment),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Appointment appointment) {
    AlertDialog dialog = AlertDialog(
      title: Text("Delete appointment \"${appointment.description}\"?"),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: () {
            FirebaseRepository.instance.deleteAppointmentForTechnician(appointment.id);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}
