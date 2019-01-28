import 'package:flutter/material.dart';
import 'package:service_app/screens/root_page.dart';
import 'package:service_app/services/authentication.dart';

void main() => runApp(ServiceApp());

class ServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("Rendering ServiceApp");
    /*
    FirebaseRepository.instance.createCustomerForTechnician(Customer("Fiducia", "mail@fiducia.com", "+497234512355",
        Address("Fiduciastraße", "20", "76227", "Karlsruhe", "Germany", 48.992988, 8.4463413)));

    FirebaseRepository.instance.createCustomerForTechnician(Customer("SAP Deutschland SE & Co. KG", "mail@sap.com",
        "+49544534456452", Address("Hasso-Plattner-Ring", "7", "69190", "Walldorf", "Germany", 49.2930353, 8.6411346)));

    FirebaseRepository.instance.createCustomerForTechnician(Customer(
        "EnBW Energie Baden-Württemberg AG",
        "mail@enbw.com",
        "+497643463456",
        Address("Durlacher Allee", "93", "76131", "Karlsruhe", "Germany", 48.9929866, 8.4310205)));
        */

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Service App",
      theme: new ThemeData(
        primaryColor: Colors.amber,
        primaryColorLight: Colors.white,
        primaryColorDark: Color(0xffb1bfca),
        secondaryHeaderColor: Colors.blueAccent[700],
        accentColor: Colors.blueAccent[700],
        canvasColor: Colors.white,
      ),
      home: new RootPage(auth: new FireAuth()),
    );
  }
}
