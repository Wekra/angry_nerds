import 'package:flutter/material.dart';
import 'homepage.dart';

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
