import 'package:flutter/material.dart';
import 'package:service_app/screens/appointment_list.dart';

void main() => runApp(ServiceApp());

class ServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service App',
      theme: new ThemeData(
        primaryColor: Colors.amber,
        canvasColor: Colors.white,
      ),
      home: ServiceHomePage(),
    );
  }
}
