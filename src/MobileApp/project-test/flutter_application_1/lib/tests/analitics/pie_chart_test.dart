import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/analitics/pie_chart.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  Widget makeTestableWidget({required Widget child}) {
    return MaterialApp(home: child);
  }

  group('BarChartWithSelector Tests', () {
    testWidgets('Initial state is correct with data', (WidgetTester tester) async {
      // Mock data for different months
      List<Receipt> mockData = [
        Receipt(
          receipt_id: '12345',
          shop_name: 'Shop1',
          type: 'Type1',
          date: DateTime.now(),
          total: 100
          ),
        Receipt(
          receipt_id: '12346',
          shop_name: "Shop2",
          date: DateTime(DateTime.now().year, DateTime.now().month - 1, 10),
          total: 200,
          type: 'Type2',
        ),
      ];

      await tester.pumpWidget(makeTestableWidget(child: BarChartWithSelector(data: mockData)));

      // Check if the initial month is displayed correctly
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM').format(now);
      expect(find.text(DateFormat('yyyy-MM').format(now)), findsOneWidget);

      // Check for the presence of the PieChart
      expect(find.byType(PieChart), findsOneWidget);
    });

    testWidgets('Navigates to previous month correctly', (WidgetTester tester) async {
      List<Receipt> mockData = [
        Receipt(
          receipt_id: '12345',
          shop_name: 'Shop1',
          type: 'Type1',
          date: DateTime.now(),
          total: 100
          ),
        Receipt(
          receipt_id: '12346',
          shop_name: "Shop2",
          date: DateTime(DateTime.now().year, DateTime.now().month - 1, 10),
          total: 200,
          type: 'Type2',
        ),
      ];

      await tester.pumpWidget(makeTestableWidget(child: BarChartWithSelector(data: mockData)));

      // Simulate pressing the left arrow
      await tester.tap(find.byIcon(Icons.arrow_left));
      await tester.pumpAndSettle();

      DateTime previousMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
      expect(find.text(DateFormat('yyyy-MM').format(previousMonth)), findsOneWidget);

      // Additional checks for updated chart data can be added here
    });

    testWidgets('Missing Month data Tests', (WidgetTester tester) async {


      await tester.pumpWidget(makeTestableWidget(child: BarChartWithSelector(data: [])));

      // Check if the message is displayed when there is no data
      expect(find.text('No data for this month'), findsOneWidget);
  
    });
  });
}
