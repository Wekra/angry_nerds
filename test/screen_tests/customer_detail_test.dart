import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/data/model/customer.dart';
import 'package:service_app/screens/customer_detail.dart';

void main() {
  testWidgets('Create a new customer datatab', (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
        home: new Scaffold(
            body: new _CustomerDataTab(new Customer(
                'Fiducia',
                'mail@fiducia.com',
                '+497234512355',
                new Address('Fiduciastraße', '20', '76227', 'Karlsruhe', 'Germany', 48.9929880,
                    8.4463410))))));

    expect(find.widgetWithText(ListTile, 'Fiducia'), findsOneWidget);
    expect(find.widgetWithText(ListTile, '+497234512355'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'mail@fiducia.com'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Fiduciastraße 20\n76227 Karlsruhe\nGermany'),
        findsOneWidget);
    expect(find.byType(Expanded), findsOneWidget); //Container for the GoogleMap widget
  });
}
