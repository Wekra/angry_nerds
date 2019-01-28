import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/main.dart';
import 'package:service_app/screens/appointment_list.dart';
import 'package:service_app/screens/root_page.dart';

void main() {
  testWidgets('Main page should render the Root Page', (WidgetTester tester) async {
    /// Build our app and trigger a frame.
    await tester.pumpWidget(new ServiceApp());
    /// Expect main page to to render the root page
    expect(find.byType(RootPage), findsOneWidget);
  });
}
