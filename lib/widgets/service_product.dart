import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/data/model/service_product.dart';

class ServiceProductListTile extends StatelessWidget {
  final ServiceProduct serviceProduct;

  ServiceProductListTile(this.serviceProduct);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(serviceProduct.name),
      subtitle: Text("${serviceProduct.description}\nPurchase date: ${serviceProduct.purchaseDate.toIso8601String()}"),
      trailing: Text(
        serviceProduct.serialNumber,
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
