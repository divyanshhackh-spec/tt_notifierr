import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tt_notifier/main.dart';

void main() {
  testWidgets('TT-Notifier app builds and shows login screen',
      (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const TTNotifierApp());

    // Check that the login screen title appears
    expect(find.text('TT-Notifier'), findsOneWidget);
    expect(find.text('PM SHRI KV No. 2 Jaipur'), findsOneWidget);
  });
}
