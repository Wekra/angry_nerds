import 'package:flutter/material.dart';
import 'package:service_app/data/model/part.dart';

class PriceWidget extends StatelessWidget {
  int price;
  Currency currency;
  TextStyle style;

  PriceWidget(this.price, this.currency, this.style);

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

    return new Text(
      finalText,
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      style: style,
    );
  }
}
