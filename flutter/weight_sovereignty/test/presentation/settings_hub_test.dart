import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weight_sovereignty/src/presentation/screens/settings/settings_hub_screen.dart';

void main() {
  testWidgets('Settings hub shows four preset sections', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsHubScreen()),
    );

    expect(find.text('Food presets'), findsOneWidget);
    expect(find.text('Exercise presets'), findsOneWidget);
    expect(find.text('Workout templates'), findsOneWidget);
    expect(find.text('Daily log profiles'), findsOneWidget);
  });
}
