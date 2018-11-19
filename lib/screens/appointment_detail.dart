//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget{

  final appointmentKey;

  AppointmentPage(this.appointmentKey);

  @override
  _AppointmentPageState createState() {
    return _AppointmentPageState();
  }
}

class _AppointmentPageState extends State<AppointmentPage> {

//  TODO sync the appointment from Firebase
//  DatabaseReference _appointmentRef;
  String appointmentKey;

  @override
  void initState() {
    appointmentKey = widget.appointmentKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        /// TODO pass Customer
        title: Text('Service Appointment'),
      ),
      body: _buildAppointmentDetail(),
    );
  }

  Widget _buildAppointmentDetail() {
    return Center(child: Text('Apppointment Detail: ${appointmentKey}'));
  }
}


