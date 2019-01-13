import 'package:flutter/material.dart';
import 'package:service_app/data/model/part.dart';

class PriceWidget extends StatelessWidget {
  final int price;
  final Currency currency;

  const PriceWidget(this.price, this.currency);

  @override
  Widget build(BuildContext context) {
    String finalText = "Price: ";

    switch (currency) {
      case Currency.eur:
        finalText += "${(price / 100.0)}€";
        break;
      case Currency.usd:
        finalText += "\$${(price / 100.0)}";
        break;
      default:
        break;
    }

    return Text(finalText);
  }
}
