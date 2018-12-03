import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/technician.dart';
import 'package:service_app/screens/home.dart';

void main() => runApp(ServiceApp());

class ServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("Rendering ServiceApp");

    // TODO Remove once we have a login page
    FirebaseRepository.init(Technician(
        "7", "Der Boss", "der@boss.de", "+491629835793", "Lieferwagen"));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Service App",
      theme: new ThemeData(
        primaryColor: Colors.blue[50],
        primaryColorLight: Colors.white,
        primaryColorDark: new Color(0xffb1bfca),
        secondaryHeaderColor: Colors.blueAccent[700],
        accentColor: Colors.blueAccent[700],
        canvasColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}
