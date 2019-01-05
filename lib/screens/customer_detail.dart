import 'package:flutter/material.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/widgets/customer_appointments.dart';
import 'package:service_app/widgets/customer_datatab.dart';

class CustomerDetailPage extends DrawerPage {
  final Customer _customer;

  CustomerDetailPage(this._customer);

  @override
  String get title => "Customer: ${_customer.name}";

  @override
  IconData get icon => Icons.people;

  @override
  _CustomerDetailPageState createState() {
    return _CustomerDetailPageState(_customer);
  }
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  final Customer _customer;

  _CustomerDetailPageState(this._customer);

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: AppBar(
              title: Text("Customer: ${_customer.name}"),
            bottom: new TabBar(
              tabs: <Widget>[new Tab(text: "Data"), new Tab(text: "Appointments"), new Tab(text: "Devices")])),
          body: new TabBarView(children: <Widget>[
            new CustomerDataTab(_customer),
            CustomerAppointmentTab(_customer),
            new Text("Here goes the list of devices")
          ]),
        ));
  }
}
