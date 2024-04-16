import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:flutter_application_1/classes/data_service_class.dart';
import 'package:flutter_application_1/classes/receipt_class.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:camera/camera.dart';


var test_user_id = "0b158bbc-3842-4dc2-b8dc-8dec91f4a92a";

void main() async {
  await dotenv.load(fileName: "lib/.env");
  
  group('Receipt Class Tests', () {
    test('Test Receipt Class', () {
      Receipt receipt = Receipt(
        receipt_id: 'f1d126ee-8d1f-4de1-ab1a-a434a868bc90',
        shop_name: 'LONDON SUPERMARKET LTD',
        type: 'grocery',
        date: DateTime.parse('2024-03-28 10:15:00'),
        total: 1244.00,
        item_purchase: json.decode(
          '{"disque be pizza a garnir": {"name": "disque be pizza a garnir", "qty": "1", "price": "4.0"},'
          ' "espuna 80g trad chorizo": {"name": "espuna 80g trad chorizo", "qty": "1", "price": "58.0"},'
          ' "denny white but .mushroom": {"name": "denny white but .mushroom", "qty": "1", "price": "149.95"},'
          ' "ch coca zero 1l": {"name": "ch coca zero 1l", "qty": "1", "price": "51.0"},'
          ' "veg he 250g rainbow tomato": {"name": "veg he 250g rainbow tomato", "qty": "1", "price": "138.0"}}'
        ),
      );

      expect(receipt.receipt_id, 'f1d126ee-8d1f-4de1-ab1a-a434a868bc90');
      expect(receipt.shop_name, 'LONDON SUPERMARKET LTD');
      expect(receipt.type, 'grocery');
      expect(receipt.date, DateTime.parse('2024-03-28 10:15:00'));
      expect(receipt.total, 1244.00);
      expect(receipt.item_purchase, json.decode(
        '{"disque be pizza a garnir": {"name": "disque be pizza a garnir", "qty": "1", "price": "4.0"},'
        ' "espuna 80g trad chorizo": {"name": "espuna 80g trad chorizo", "qty": "1", "price": "58.0"},'
        ' "denny white but .mushroom": {"name": "denny white but .mushroom", "qty": "1", "price": "149.95"},'
        ' "ch coca zero 1l": {"name": "ch coca zero 1l", "qty": "1", "price": "51.0"},'
        ' "veg he 250g rainbow tomato": {"name": "veg he 250g rainbow tomato", "qty": "1", "price": "138.0"}}'
      ));
    });
  });
}
