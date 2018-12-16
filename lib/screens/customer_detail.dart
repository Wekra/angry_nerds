import 'package:flutter/material.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/widgets/customer_datatab.dart';

class CustomerDetailPage extends DrawerPage {
  final Customer customer = new Customer("ACME", "hska-service@acme.com", "+49 172 123456",
      new Address("Moltkestraße", "30", "76133", "Karlsruhe", "Germany", 49.014951, 8.389975));

  @override
  String get title => "Customer";

  @override
  IconData get icon => Icons.people;

  @override
  _CustomerDetailPageState createState() {
    return _CustomerDetailPageState(customer);
  }
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  Customer _customer;

  _CustomerDetailPageState(Customer customer) {
    if (customer != null) {
      _customer = customer;
    } else {
      _customer = new Customer("ACME", "hska-service@acme.com", "+49 172 123456",
          new Address("Moltkestraße", "30", "76133", "Karlsruhe", "Germany", 49.014951, 8.389975));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: AppBar(
              title: Text("Customer: ${_customer.name}"),
              bottom: new TabBar(tabs: <Widget>[
                new Tab(text: "Data"),
                new Tab(text: "Appointments"),
                new Tab(text: "Devices")
              ])),
          body: new TabBarView(children: <Widget>[
            new CustomerDataTab(_customer),
            new Text("Here goes the list of appointments"),
            new Text("Here goes the list of devices")
          ]),
        ));
  }
}
