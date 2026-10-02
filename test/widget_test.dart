import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sla_api_activity/main.dart';

void main() {
  testWidgets('HomePage shows the loading state while fetching', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('API Posts'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}