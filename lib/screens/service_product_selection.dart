import 'package:flutter/material.dart';
import 'package:service_app/data/firebase_repository.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/data/model/service_product.dart';
import 'package:service_app/widgets/animated_operations_list.dart';

class ServiceProductSelection extends StatelessWidget {
  final Customer _customer;

  const ServiceProductSelection(this._customer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service products of ${_customer.name}"),
      ),
      body: AnimatedOperationsList(
          stream: FirebaseRepository.instance.getServiceProductsOfCustomer(_customer.id),
          itemBuilder: _buildServiceProductWidget),
    );
  }

  Widget _buildServiceProductWidget(
      BuildContext context, ServiceProduct serviceProduct, Animation<double> animation, int index) {
    return FadeTransition(
      opacity: animation,
      child: ListTile(
        title: Text(serviceProduct.name),
        subtitle: Text(serviceProduct.description),
        onTap: () => Navigator.pop(context, serviceProduct),
      ),
    );
  }
}
