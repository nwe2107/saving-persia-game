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
    expect(find.byIcon(Icons.expand_less), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_left), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_right), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
  });
}
