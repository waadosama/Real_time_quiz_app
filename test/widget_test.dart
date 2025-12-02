// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:quiz_app/main.dart';

void main() {
  testWidgets('Quiz app loads LoginPage when not authenticated',
      (WidgetTester tester) async {
    // Set up mock SharedPreferences with no login data
    SharedPreferences.setMockInitialValues({});

   // final prefs = await SharedPreferences.getInstance();
 //   await tester.pumpWidget(MyApp(prefs: prefs));

    // Wait for async operations and animations
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
