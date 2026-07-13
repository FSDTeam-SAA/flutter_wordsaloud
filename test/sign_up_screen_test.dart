import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_wordsaloud/features/auth/screens/sign_up_screen.dart';

void main() {
  testWidgets('shows inline validation when email is empty', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SignUpScreen()));

    await tester.ensureVisible(find.text('Send verification code'));
    await tester.tap(find.text('Send verification code'));
    await tester.pump();

    expect(find.text('You did not give your email address.'), findsOneWidget);
  });

  testWidgets('does not show email validation error when email is valid', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SignUpScreen()));

    await tester.enterText(
      find.byWidgetPredicate((widget) => widget is TextField && widget.decoration?.hintText == 'jeanne@gmail.com'),
      'test@example.com',
    );
    await tester.ensureVisible(find.text('Send verification code'));
    await tester.tap(find.text('Send verification code'));
    await tester.pump();

    expect(find.text('You did not give your email address.'), findsNothing);
    expect(find.text('Please enter a correct email address.'), findsNothing);
  });
}
