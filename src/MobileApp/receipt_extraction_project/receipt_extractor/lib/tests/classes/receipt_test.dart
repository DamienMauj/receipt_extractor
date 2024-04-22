import 'package:test/test.dart';
import 'package:receipt_extractor/classes/receipt_class.dart';
import 'dart:convert';

void main() {
  group('Receipt.fromJson', () {
    test('correctly parses a well-formed JSON object', () {
      final json = {
        "receipt_id": "123",
        "shop_information": "Test Shop",
        "type": "Grocery",
        "time": "2023-03-15T14:00:00Z",
        "total": 100.0,
        "item_purchase": "{\"Apple\": {\"quantity\": 1, \"price\": 1.0}}"
      };

      final receipt = Receipt.fromJson(json);

      expect(receipt.receipt_id, equals("123"));
      expect(receipt.shop_name, equals("Test Shop"));
      expect(receipt.type, equals("Grocery"));
      expect(receipt.date, equals(DateTime.parse("2023-03-15T14:00:00Z")));
      expect(receipt.total, equals(100.0));
      expect(receipt.item_purchase, {"Apple": {"quantity": 1, "price": 1.0}});
    });

    test("parse a bad json format", () {
      final json = {
        "receipt_id": "123",
        "shop_information": "Test Shop",
        "type": "Grocery",
        "time": "Friday",
        "total": "two hundred",
        "item_purchase": "{\"Apple\": {\"quantity\": 1, \"price\": 1.0}"
      };

      final receipt = Receipt.fromJson(json);

      expect(receipt.receipt_id, equals("Error parsing receipt"));
      expect(receipt.shop_name, equals("Error parsing receipt"));
      expect(receipt.type, equals("Error parsing receipt"));
      expect(receipt.total, equals(0.0));
      expect(receipt.item_purchase, null);
    });
    // Add more tests for optional fields, error handling, etc.
  });
}
