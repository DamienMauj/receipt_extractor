import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_extractor/pages/graph_page.dart';
import 'package:receipt_extractor/classes/receipt_class.dart';
import 'package:receipt_extractor/globals.dart' as globals;
import 'package:receipt_extractor/classes/data_service_class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:uuid/uuid.dart';


class MockDataService extends DataService {
  @override
  Future<List<Receipt>> fetchReceipts(String user_id) async {
    return [
       Receipt(
          receipt_id: Uuid().v4(),
          shop_name: "Shop 1",
          type: "Groceries",
          date: DateTime.now().subtract(Duration(days: 1)), 
          total: 100),
      Receipt(
          receipt_id: Uuid().v4(),
          shop_name: "Shop 2",
          type: "Electronics",
          date: DateTime.now(), 
          total: 200),
    ];
  }
}

class EmptyMockDataService extends DataService {
  @override
  Future<List<Receipt>> fetchReceipts(String user_id) async {
    return [];
  }
}

void main() { 
    
    group("Graph page initialization", () {
      late MockDataService mockDataService;
      late EmptyMockDataService emptyDataServices;
      setUp(() {
        mockDataService = MockDataService();
        emptyDataServices = EmptyMockDataService();
        });

      testWidgets("graph page initialization with data", (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: GraphPage(dataService: mockDataService,)));
        // Wait till the end of graph loading animation
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("Graph Page")), findsOneWidget);
        expect(find.byKey(const Key("Tab Bar")), findsOneWidget);
        expect(find.byKey(const Key("Tab Bar View")), findsOneWidget);
        expect(find.byKey(const Key("BottomNavigationBar")), findsOneWidget);

      });

      testWidgets("graph page initialization with no data", (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: GraphPage(dataService: emptyDataServices,)));
        // Wait till the end of graph loading animation
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("Graph Page")), findsOneWidget);
        expect(find.byKey(const Key("Tab Bar")), findsOneWidget);
        expect(find.byKey(const Key("No Data Message")), findsOneWidget);
        expect(find.byKey(const Key("BottomNavigationBar")), findsOneWidget);
      });

      testWidgets("Changing displayed graph", (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: GraphPage(dataService: mockDataService,)));
        // Wait till the end of graph loading animation
        await tester.pumpAndSettle(); 

        // Tap on the second tab
        await tester.tap(find.byKey(const Key("Tab 2")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("Pie Chart")), findsOneWidget);

        // Tap on the first tab
        await tester.tap(find.byKey(const Key("Tab 1")));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key("Line Chart")), findsOneWidget);
      });

    
    });

    
}