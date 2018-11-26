import 'package:flutter/material.dart';
import 'package:service_app/data/model/part.dart';

class PriceWidget extends StatelessWidget {
  int price;
  Currency currency;

  PriceWidget(this.price, this.currency);

  @override
  Widget build(BuildContext context) {
    String currencySymbol = "";

    switch (currency) {
      case Currency.euro:
        currencySymbol = "€";
        break;
      case Currency.usd:
        currencySymbol = "\$";
        break;
      default:
        currencySymbol = "";
        break;
    }
    // TODO: implement build
    return new Text("Price: ${(price / 100.0)}" + currencySymbol);
  }
}
