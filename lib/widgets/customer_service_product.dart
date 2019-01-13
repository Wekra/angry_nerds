import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service_app/data/model/service_product.dart';

class CustomerServiceProduct extends StatelessWidget {
  final ServiceProduct serviceProduct;

  CustomerServiceProduct(this.serviceProduct);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(serviceProduct.name),
                subtitle: Text("Name"),
              ),
              ListTile(
                title: Text(serviceProduct.serialNumber),
                subtitle: Text("Serialnumber"),
              ),
              ListTile(
                title: Text(serviceProduct.description),
                subtitle: Text("Description"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
