import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/main.dart';
import 'package:service_app/screens/appointment_list.dart';

void main() {
  testWidgets('Main page should render the appointment list', (WidgetTester tester) async {
    /// Build our app and trigger a frame.
    await tester.pumpWidget(new ServiceApp());
    /// Expect main page to to render the appointment list
    expect(find.byType(AppointmentListPage), findsOneWidget);
  });
}
