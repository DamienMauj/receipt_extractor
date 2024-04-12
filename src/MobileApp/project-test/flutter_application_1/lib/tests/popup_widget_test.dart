import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/widgets/popup.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  

  testWidgets('Popup widget tester', (tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: ReceiptPopup(buttonText: '', popupText: 'test', isNewReceipt: true),
      ),
    );

    List<String> keys = ['Shop', 'Type', 'Date', 'Total'];

    for (String key in keys) {
      final titleFinder = find.byKey(Key('$key text'));
      final textFieldFinder = find.byKey(Key("$key field"));
      expect(titleFinder, findsOneWidget);
      expect(textFieldFinder, findsOneWidget);
    }

  });

  testWidgets('Add and Delete Item Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ReceiptPopup(buttonText: '', popupText: 'test', isNewReceipt: true),
      ),
    );

    List<String> keys = ['Name', 'Qty', 'Price'];

    for (String key in keys) {
      final itemElementFinder = find.byKey(Key('Item 1 $key Field'));
      expect(itemElementFinder, findsNothing);
    }

    // Press the add item button
    await tester.tap(find.byKey(Key('Add Item Button')));
    await tester.pumpAndSettle();

    for (String key in keys) {
      final itemElementFinder = find.byKey(Key('Item 1 $key Field'));
      expect(itemElementFinder, findsOneWidget);
    }

    // Press the delete item button
    await tester.tap(find.byKey(Key('Item 1 delete button')));
    await tester.pumpAndSettle();

    for (String key in keys) {
      final itemElementFinder = find.byKey(Key('Item 1 $key Field'));
      expect(itemElementFinder, findsNothing);
    }
  });

  testWidgets('Popup widget tester', (tester) async {
  });

  testWidgets('Close button test', (WidgetTester tester) async {
  // Build your app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: ReceiptPopup(buttonText: '', popupText: 'test', isNewReceipt: true),
      ),
    );

    final titleFinder = find.byKey(Key('Shop text'));
    expect(titleFinder, findsOneWidget); 
    // Find the 'Close' button
    final closeButton = find.text('Close');

    // Verify that the 'Close' button exists
    expect(closeButton, findsOneWidget);

    // Tap the 'Close' button
    await tester.tap(closeButton);

    // Trigger a frame
    await tester.pumpAndSettle();

    // Verify that the popup was closed
    final titleFinder2 = find.byKey(Key('Shop Name text'));
    expect(titleFinder2, findsNothing); 

  });

}