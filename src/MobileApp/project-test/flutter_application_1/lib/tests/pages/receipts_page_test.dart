import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/pages/list_page.dart';
import 'package:flutter_application_1/widgets/navigation_bar.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';
import 'package:flutter_application_1/widgets/popup.dart'; // Make sure the widget is correctly named here
import 'package:mockito/mockito.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:flutter_application_1/classes/data_service_class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


// class MockDataService extends Mock implements DataService {}
class MockDataService extends DataService {
  @override
  Future<List<Receipt>> fetchReceipts(String user_id) async {
    return [
       Receipt(
          receipt_id: Uuid().v4(),
          shop_name: "Shop 1",
          type: "Groceries",
          date: DateTime(2024, 04, 10), 
          total: 100),
      Receipt(
          receipt_id: Uuid().v4(),
          shop_name: "Shop 2",
          type: "Electronics",
          date: DateTime(2024, 04, 10), 
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

  group('ReceiptsPage Tests', () {
    late MockDataService mockDataService;
    late EmptyMockDataService emptyDataServices;
    late List<Receipt> testReceipts;

    setUp(() async {
      await dotenv.load(fileName: "lib/.env");  
      mockDataService = MockDataService();
      emptyDataServices = EmptyMockDataService();

      globals.user_id = "0b158bbc-3842-4dc2-b8dc-8dec91f4a92a"; // Setting a test user id
    });

    testWidgets('ReceiptsPage initializes with fetched data', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ReceiptsPage(dataService: mockDataService)));
      await tester.pump(); // Triggers a frame
      expect(find.byKey(const Key("BottomNavigationBar")), findsOneWidget);
      expect(find.byKey(const Key("row 0")), findsOneWidget);
      expect(find.byKey(const Key("row 1")), findsOneWidget);
    });

    testWidgets('ReceiptsPage initializes with no data', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ReceiptsPage(dataService: emptyDataServices)));
      await tester.pump(); // Triggers a frame
      expect(find.byKey(const Key("BottomNavigationBar")), findsOneWidget);
      expect(find.byKey(const Key("No Receipts Message")), findsOneWidget);
    });

    testWidgets('Test add button', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ReceiptsPage(dataService: mockDataService)));
      await tester.pump(); // Triggers a frame
      await tester.tap(find.byKey(const Key("Add Button")));
      await tester.pump(); // Triggers a frame
      await tester.pump(const Duration(seconds: 1)); // Wait for the popup to appear
      expect(find.byKey(const Key("Receipt Popup")), findsOneWidget);
    });

    testWidgets('Test edit feature', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: ReceiptsPage(dataService: mockDataService)));
      await tester.pump(); // Triggers a frame
      await tester.tap(find.byKey(const Key("row 0")));
      await tester.pump(); // Triggers a frame
      await tester.pump(const Duration(seconds: 1)); // Wait for the popup to appear
      expect(find.byKey(const Key("Receipt Popup")), findsOneWidget);
      //find "shop 1" in popup
      expect(find.text("Shop 1"), findsExactly(2));
      expect(find.text("Groceries"), findsOneWidget);
    });

  });
}
