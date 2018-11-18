import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';


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

  /// Initialize State: get db reference and start subscription
  @override
  void initState() {
    super.initState();
    _appointmentRef = FirebaseDatabase.instance.reference().child('appointment');
    _appointmentSubscription =
        _appointmentRef.limitToLast(10).onChildAdded.listen((Event event) {
          print('Child added: ${event.snapshot.value}');
        }, onError:( Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }
  
  /// Destroy subscriptions on leave
  @override
  void dispose() {
    super.dispose();
    _appointmentSubscription.cancel();
  }

  /// Builds the service appoitnment page
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Service Appointments'),
        backgroundColor: Colors.teal[300],
      ),
      body: _buildList(_appointmentRef),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add),
          backgroundColor: Colors.purpleAccent,
          onPressed: (){_createAppointment();}
      ),
    );
  }

  /// Builds the list widget as firebase Animated list
  Widget _buildList(collection) {
    return FirebaseAnimatedList(
        query: collection,
        reverse: false,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          return SizeTransition(
              sizeFactor: animation,
              child: _buildListItem(snapshot.value)
          );
        });
  }

  /// Builds the list-item widget
  Widget _buildListItem(item) {
    return ListTile(
      title: Text(item['description'].toString()),
      subtitle: Text(item['customer']),
    );
  }

  /// Creates a new Appointment in firebase
  void _createAppointment(){
    var creation = new DateTime.now().millisecondsSinceEpoch.toString();
    var dummyAppointment = {
      "created": creation,
      "description": "Fix the printer",
      "scheduled-start": "timestamp",
      "scheduled-end": "tiimestamp",
      "service-start": "null",
      "service-end": "null",
      "customer": "nike",
      "target": "should be target ID",
      "parts": [
        {"part-id-1":"part-id-1"}
      ]
    };
    _appointmentRef.push().set(dummyAppointment).catchError(_onDBError);
  }
  /// Database error handler
  void _onDBError(Object o) {
    final DatabaseError error = o;
    print('Error: ${error.code} ${error.message}');
  }
}


