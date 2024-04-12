import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/navigation_bar.dart';
// import 'package:flutter_application_1/pages/list_page.dart';
// import 'package:flutter_application_1/pages/camera_page.dart';
// import 'package:flutter_application_1/pages/graph_page.dart';
// import 'package:mockito/mockito.dart';

void main() {
  // Mock Navigator
  // final mockObserver = MockNavigatorObserver();

  group('CustomBottomNavigationBar Tests', () {
    testWidgets('Testing Receipt Button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
          ),
        ),
      );

      final receiptButtonFinder = find.byIcon(const IconData(0xe50d, fontFamily: 'MaterialIcons'));

      expect(receiptButtonFinder, findsOneWidget);

      // press the button
      await tester.tap(receiptButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('Receipts Page')), findsOneWidget);
    });

    testWidgets('Testing Camera Button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
          ),
        ),
      );

      final receiptButtonFinder = find.byIcon(Icons.camera);

      expect(receiptButtonFinder, findsOneWidget);

      // press the button
      await tester.tap(receiptButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('Camera Page')), findsOneWidget);

    });

    testWidgets('Testing Graph Button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 0),
          ),
        ),
      );

      final receiptButtonFinder = find.byIcon(IconData(0xf59b, fontFamily: 'MaterialIcons'));

      expect(receiptButtonFinder, findsOneWidget);

      // press the button
      await tester.tap(receiptButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byKey(Key('Graph Page')), findsOneWidget);
    });

  });
}
