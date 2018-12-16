import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class CustomerListAll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("All customers"),
      ),
      body: AnimatedOperationsList(stream: FirebaseRepository.instance.getAllCustomers(), itemBuilder: _buildListItem),
    );
  }

  Widget _buildListItem(BuildContext context, Customer customer, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text(customer.name),
        subtitle: Text(customer.address.toString()),
        onTap: () => Navigator.pop(context, customer),
      ),
    );
  }
}
