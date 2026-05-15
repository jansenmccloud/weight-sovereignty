import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weight_sovereignty/src/presentation/app_root.dart';

void main() {
  testWidgets('shows loading while database opens', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: AppRoot()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
