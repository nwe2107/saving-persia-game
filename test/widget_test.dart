import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:saving_persia/main.dart';

void main() {
  testWidgets('shows the rescue HUD and controls', (WidgetTester tester) async {
    await tester.pumpWidget(const SavingPersiaApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 16));

    expect(find.text('Mission: Save Persia'), findsOneWidget);
    expect(find.text('Scarves'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_left), findsOneWidget);
    expect(find.byIcon(Icons.arrow_right), findsOneWidget);
    expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
  });
}
