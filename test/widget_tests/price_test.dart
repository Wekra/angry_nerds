import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/data/model/part.dart';
import 'package:service_app/widgets/price.dart';

void main() {
  testWidgets('Create Price Widget with Euro price',
      (WidgetTester tester) async {
    await tester.pumpWidget(new PriceWidget(354, Currency.eur, TextStyle()));

    expect(find.text('Price: 3.54€'), findsOneWidget);
  });

  testWidgets('Create Price Widget with Dollar price',
      (WidgetTester tester) async {
    await tester.pumpWidget(new PriceWidget(354, Currency.usd, TextStyle()));

    expect(find.text('Price: \$3.54'), findsOneWidget);
  });
}
