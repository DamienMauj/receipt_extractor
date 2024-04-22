import 'package:flutter/material.dart';
import 'package:receipt_extractor/widgets/analitics/line_chart.dart';
import 'package:receipt_extractor/classes/receipt_class.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

void main() {
  // Helper function to create a testable widget
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  group('AnimatedLineChartWidget Tests', () {
    testWidgets('Renders correctly with data', (WidgetTester tester) async {
      // Create some mock data
      List<Receipt> mockData = [
        Receipt(
          receipt_id: Uuid().v4(),
          shop_name: "Shop 1",
          type: "Groceries",
          date: DateTime(2024, 04, 10), 
          total: 100),
        // Add more data as needed
      ];

      // Build the widget
      await tester.pumpWidget(makeTestableWidget(child: AnimatedLineChartWidget(data: mockData)));

      // Verify that the line chart is displayed
      expect(find.byType(AnimatedLineChartWidget), findsOneWidget);
    });

    testWidgets('Displays "No data for this month" message when there are no receipts', (WidgetTester tester) async {
      // Build the widget with empty data
      await tester.pumpWidget(makeTestableWidget(child: AnimatedLineChartWidget(data: [])));

      // Verify that the message is displayed
      expect(find.text('No data for this month'), findsOneWidget);
    });

    testWidgets('Month navigation updates the chart', (WidgetTester tester) async {
      // Create mock data for two different months
      List<Receipt> mockData = [
        Receipt(
          receipt_id: Uuid().v4(),
          shop_name: "Shop 1",
          type: "Groceries",
          date: DateTime(2024, 04, 10), 
          total: 100),
        Receipt(
          receipt_id: Uuid().v4(),
          shop_name: "Shop 1",
          type: "Groceries",
          date: DateTime(2024, 03, 10), 
          total: 100),
        // Add more data as needed
      ];

      // Build the widget
      await tester.pumpWidget(makeTestableWidget(child: AnimatedLineChartWidget(data: mockData)));

      // Initially, it should show data for the current month
      DateTime now = DateTime.now();
      String currentMonth = DateFormat('MMM yyyy').format(now);
      expect(find.text(currentMonth), findsOneWidget);

      // Simulate pressing the left arrow to go to the previous month
      await tester.tap(find.byIcon(Icons.arrow_left));
      await tester.pumpAndSettle(); // Wait for animations to settle

      // Verify that the month displayed is updated
      DateTime previousMonth = DateTime(now.year, now.month - 1);
      String previousMonthText = DateFormat('MMM yyyy').format(previousMonth);
      expect(find.text(previousMonthText), findsOneWidget);
    });

  });
}
