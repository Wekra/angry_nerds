import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/screens/appointment_list.dart';
import 'package:service_app/screens/foo_bar.dart';

void main() => runApp(ServiceApp());

class ServiceApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    debugPrint("Rendering ServiceApp");
    FirebaseRepository.init(3);
    return MaterialApp(
      title: 'Service App',
      theme: new ThemeData(
        primaryColor: Colors.blue[50],
        primaryColorLight: Colors.white,
        primaryColorDark: new Color(0xffb1bfca),
        secondaryHeaderColor: Colors.blueAccent[700],
        accentColor: Colors.blueAccent[700],
        canvasColor: Colors.white,
      ),
      home: AppointmentListPage(),
      routes: <String, WidgetBuilder> {
        '/appointment_list': (BuildContext context) => AppointmentListPage(),
        '/test': (BuildContext context) => FooBarPage(),
      },
    );
  }
}
