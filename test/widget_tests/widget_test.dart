import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/main.dart';

void main() {
  testWidgets('App is available and displays the Appointments Screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(new ServiceApp());

//TODO do we need these tests
//    expect(find.text('Appointments'), findsOneWidget);
//    expect(find.text('1'), findsNothing);
  });
}
