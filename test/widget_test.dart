import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdv_restaurant/main.dart';

void main() {
  testWidgets('PDV Restaurant app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: PDVRestaurantApp()));

    // Verify that the app starts without crashing
    expect(find.byType(FluentApp), findsOneWidget);
  });
}
