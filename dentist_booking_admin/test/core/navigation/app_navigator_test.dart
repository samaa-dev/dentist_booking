import 'package:dentist_booking_admin/core/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppNavigator', () {
    testWidgets('dismissOverlays pops until first route', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: rootNavigatorKey,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('Overlay'),
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Overlay'), findsOneWidget);

      AppNavigator.dismissOverlays();
      await tester.pumpAndSettle();

      expect(find.text('Overlay'), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });

    test('dismissOverlays is safe when navigator is not mounted', () {
      expect(AppNavigator.dismissOverlays, returnsNormally);
    });
  });
}
