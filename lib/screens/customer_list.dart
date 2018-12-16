import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/screens/customer_detail.dart';
import 'package:service_app/screens/drawer_page.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class CustomerListPage extends DrawerPage {
  @override
  _CustomerListPageState createState() {
    return _CustomerListPageState();
  }

  @override
  String get title => "Customers";

  @override
  IconData get icon => Icons.person;
}

class _CustomerListPageState extends State<CustomerListPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: AnimatedOperationsList(
          stream: FirebaseRepository.instance.getCustomersOfTechnician(), itemBuilder: _buildListItem),
    );
  }

  Widget _buildListItem(BuildContext context, Customer customer, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text(customer.name),
        subtitle: Text(customer.address.toString()),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDetailPage(customer))),
      ),
    );
  }
}
