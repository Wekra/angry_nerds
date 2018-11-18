import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import '../firebase/firebase_appointment.dart';
import 'package:startup_namer/widgets/connected_list.dart';

class ServiceHomePage extends StatefulWidget {
  @override
  _ServiceHomePageState createState() {
    return _ServiceHomePageState();
  }
}

///Service home page renders the appointment list
class _ServiceHomePageState extends State<ServiceHomePage> {

  DatabaseReference _appointmentRef;
  StreamSubscription<Event> _appointmentSubscription;

  /// Initialize State: get db reference
  @override
  void initState() {
    super.initState();
    _appointmentRef = FirebaseDatabase.instance.reference().child('appointment');
  }
  
  /// Destroy subscriptions on leave
  @override
  void dispose() {
    super.dispose();
    _appointmentSubscription.cancel();
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


