import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:sla_api_activity/main.dart';
import 'package:sla_api_activity/services/api_service.dart';

ApiService serviceReturning(String body, {int status = 200}) {
  return ApiService(
    client: MockClient((_) async => http.Response(body, status)),
  );
}

const twoPosts = '[{"userId":1,"id":1,"title":"first title","body":"first body"},'
    '{"userId":2,"id":2,"title":"second title","body":"second body"}]';

void main() {
  testWidgets('shows a loader while the request is in flight', (tester) async {
    final pending = Completer<http.Response>();
    final service = ApiService(
      client: MockClient((_) => pending.future),
    );

    await tester.pumpWidget(MyApp(apiService: service));
    await tester.pump();

    expect(find.text('API Posts'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    pending.complete(http.Response(twoPosts, 200));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('renders posts through ListView.builder on success', (
    tester,
  ) async {
    await tester.pumpWidget(MyApp(apiService: serviceReturning(twoPosts)));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('first title'), findsOneWidget);
    expect(find.text('first body'), findsOneWidget);
    expect(find.text('second title'), findsOneWidget);

    final listView = tester.widget<ListView>(find.byType(ListView));
    expect(listView, isA<ListView>());
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('shows an error with retry on failure', (tester) async {
    await tester.pumpWidget(
      MyApp(apiService: serviceReturning('bad', status: 500)),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Failed to load posts'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('retry re-issues the request and succeeds', (tester) async {
    var calls = 0;
    final service = ApiService(
      client: MockClient((_) async {
        calls++;
        if (calls == 1) return http.Response('bad', 500);
        return http.Response(twoPosts, 200);
      }),
    );

    await tester.pumpWidget(MyApp(apiService: service));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(calls, 2);
    expect(find.text('first title'), findsOneWidget);
  });

  testWidgets('shows the empty state for an empty list', (tester) async {
    await tester.pumpWidget(MyApp(apiService: serviceReturning('[]')));
    await tester.pumpAndSettle();

    expect(find.text('No posts found.'), findsOneWidget);
  });
}