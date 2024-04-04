import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/classes/data_service_class.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('DataService Tests', () {
    test('fetchReceipts returns a list of Receipts on a successful response', () async {
      final client = MockClient();
      final dataService = DataService(); // Modify DataService to accept an http.Client for testing
      when(client.get(Uri.parse("http://${dotenv.env['CURRENT_IP']}:8000/getReceipt/"))).thenAnswer((_) async => http.Response('[{"receipt_id": "123", ...}]', 200)); // Mock response

      expect(await dataService.fetchReceipts(), isA<List<Receipt>>());
    });

    // Add more tests for different HTTP responses and error cases
  });

  // group('Receipt Tests', () {
  //   test('fromJson creates a valid Receipt object', () {
  //     var json = {"receipt_id": "123", "shop_name": "Test Shop"}; // Add the rest of the fields
  //     var receipt = Receipt.fromJson(json);

  //     expect(receipt, isA<Receipt>());
  //     expect(receipt.receipt_id, '123');
  //     // Add more assertions for other fields
  //   });

  //   // Add more tests for handling incorrect or incomplete JSON
  // });
}
