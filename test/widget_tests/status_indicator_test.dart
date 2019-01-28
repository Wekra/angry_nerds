import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:service_app/data/model/warehouse_order.dart';
import 'package:service_app/widgets/status_indicator.dart';

void main() {
  testWidgets('Create Status indicator for status "open"', (WidgetTester tester) async {
    await tester.pumpWidget(new StatusIndicatorWidget(WarehouseOrderStatus.open));

    expect(find.byIcon(FontAwesomeIcons.hourglassStart), findsOneWidget);
    expect(find.widgetWithIcon(StatusIndicatorWidget, FontAwesomeIcons.hourglassStart),
        findsOneWidget);
  });

  testWidgets('Create Status indicator for status "inProgress"', (WidgetTester tester) async {
    await tester.pumpWidget(new StatusIndicatorWidget(WarehouseOrderStatus.inProgress));

    expect(find.byIcon(FontAwesomeIcons.spinner), findsOneWidget);
    expect(find.widgetWithIcon(StatusIndicatorWidget, FontAwesomeIcons.spinner), findsOneWidget);
  });

  testWidgets('Create Status indicator for status "delivered"', (WidgetTester tester) async {
    await tester.pumpWidget(new StatusIndicatorWidget(WarehouseOrderStatus.delivered));

    expect(find.byIcon(FontAwesomeIcons.check), findsOneWidget);
    expect(find.widgetWithIcon(StatusIndicatorWidget, FontAwesomeIcons.check), findsOneWidget);
  });

  testWidgets('Create Status indicator for status "cancelled"', (WidgetTester tester) async {
    await tester.pumpWidget(new StatusIndicatorWidget(WarehouseOrderStatus.cancelled));

    expect(find.byIcon(Icons.cancel), findsOneWidget);
    expect(find.widgetWithIcon(StatusIndicatorWidget, Icons.cancel), findsOneWidget);
  });
}
