// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:unspoken/main.dart';

void main() {
  testWidgets('App loads and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const UnspokenApp());

    // Verify that the app bar title is present.
    expect(find.text('Autism Support'), findsOneWidget);

    // Verify bottom navigation bar is present.
    expect(find.text('Feelings/Needs'), findsOneWidget);
    expect(find.text('Calm Tips'), findsOneWidget);
  });
}
