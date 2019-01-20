import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_app/screens/login_signup_page.dart';
import 'package:service_app/services/authentication.dart';


class MockAuth implements BaseAuth {
  @override
  Future<BaseUser> getCurrentUser() {
    return null;
  }

  @override
  Future<String> signIn(String email, String password) {
    return null;
  }

  @override
  Future<void> signOut() {
    return null;
  }

  @override
  Future<String> signUp(String email, String password) {
    return null;
  }
}

void callMock () {}

void main() {

  testWidgets('Text Login page', (WidgetTester tester) async {
    LoginSignUpPage logInPage = new LoginSignUpPage(new MockAuth(), callMock);

    await tester.pumpWidget(new MaterialApp(home: logInPage));
    expect(find.byType(Form), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(MaterialButton, 'Login'), findsOneWidget);
    expect(find.widgetWithText(FlatButton, 'Create an account'), findsOneWidget);
  });
}
