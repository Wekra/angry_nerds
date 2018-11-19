import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../firebase/firebase_appointment.dart';
import '../widgets/connected_list.dart';

class AppointmentListPage extends StatefulWidget {
  @override
  _AppointmentListPageState createState() {
    return _AppointmentListPageState();
  }
}

///Service home page renders the appointment list
class _AppointmentListPageState extends State<AppointmentListPage> {

  DatabaseReference _appointmentRef;

  /// Initialize State: get db reference
  @override
  void initState() {
    super.initState();
    _appointmentRef = FirebaseDatabase.instance.reference().child('appointment');
  }

  /// Builds the service appointment page
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Service Appointments'),
        backgroundColor: Colors.teal[300],
      ),
      body: ConnectedList(_appointmentRef, _buildListItem),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: Colors.purpleAccent,
          onPressed: () {
            FirebaseAppointment.createAppointment(_appointmentRef, null).catchError(_onDBError);
          }
      ),
    );
  }

  /// Builds the list-item widget
  Widget _buildListItem(item) {
    return ListTile(
      title: Text(item['description'].toString()),
      subtitle: Text(item['customer']),
    );
  }

  /// Database error handler
  void _onDBError(Object o) {
    final DatabaseError error = o;
    print('Error: ${error.code} ${error.message}');
  }
}


