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
  group('Data Services Tests', () {
    test('fetch receipt test', () async {
      DataService data_service = DataService();
       Receipt receipt1 = Receipt(
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

      // Create the second receipt object
      Receipt receipt2 = Receipt(
        receipt_id: 'f1d126ee-8d1f-4de1-ab1a-a434a868bc91',
        shop_name: 'ABC Stationery Shop',
        type: 'stationery',
        date: DateTime.parse('2024-03-29 15:30:00'),
        total: 300.50,
        item_purchase: json.decode(
          '{"pen": {"name": "pen", "qty": "2", "price": "5.25"},'
          ' "notebook": {"name": "notebook", "qty": "3", "price": "20.0"},'
          ' "pencil": {"name": "pencil", "qty": "1", "price": "2.75"}}'
        ),
      );

      // Create the third receipt object
      Receipt receipt3 = Receipt(
        receipt_id: 'f1d126ee-8d1f-4de1-ab1a-a434a868bc92',
        shop_name: 'Gadget Emporium',
        type: 'electronics',
        date: DateTime.parse('2024-03-30 11:45:00'),
        total: 1899.99,
        item_purchase: json.decode(
          '{"smartphone": {"name": "smartphone", "qty": "1", "price": "899.99"},'
          ' "laptop": {"name": "laptop", "qty": "1", "price": "999.00"}}'
        ),
      );

      List<Receipt> expected_receipts = [receipt3, receipt2, receipt1];

      List<Receipt> result = await data_service.fetchReceipts(test_user_id);

      expect(result, isA<List<Receipt>>());
      expect(result.length, 3);
      
      for (int i = 0; i < result.length; i++) {
        expect(result[i].receipt_id, expected_receipts[i].receipt_id);
        expect(result[i].shop_name, expected_receipts[i].shop_name);
        expect(result[i].type, expected_receipts[i].type);
        expect(result[i].date, expected_receipts[i].date);
        expect(result[i].total, expected_receipts[i].total);
        expect(result[i].item_purchase, expected_receipts[i].item_purchase);
      }
    });

    test('Send Picture test', () async {
      DataService data_service = DataService();

      // Create a dummy XFile object
      XFile dummy_image = XFile('lib/tests/assets/image.png');
      String user_id = test_user_id;

      Response responce = await data_service.sendPicture(dummy_image, user_id); 
      expect(responce.statusCode, 200);
     
      expect(json.decode(responce.body), isA<Map<String, dynamic>>());
      Map<String, dynamic> responce_data = json.decode(responce.body);

      expect(responce_data.containsKey('results'), true);
      expect(responce_data["results"].containsKey('shop_information'), true);
      expect(responce_data["results"].containsKey('type'), true);
      expect(responce_data["results"].containsKey('time'), true);
      expect(responce_data["results"].containsKey('total'), true);
    });

    test("send Reviewed Data Test", () async {

      DataService data_service = DataService();
      Map<String, dynamic> data = {
        "results" : {
          "receipt_id": "f1d126ee-8d1f-4de1-ab1a-a434a868bc90",
          "user_id": test_user_id,
          "shop_information": "LONDON SUPERMARKET LTD",
          "type": "grocery",
          "time": "2024-03-28 10:15:00",
          "total": 1244.00,
          "item_purchase": {
            "disque be pizza a garnir": {"name": "disque be pizza a garnir", "qty": "1", "price": "4.0"},
            "espuna 80g trad chorizo": {"name": "espuna 80g trad chorizo", "qty": "1", "price": "58.0"},
            "denny white but .mushroom": {"name": "denny white but .mushroom", "qty": "1", "price": "149.95"},
            "ch coca zero 1l": {"name": "ch coca zero 1l", "qty": "1", "price": "51.0"},
            "veg he 250g rainbow tomato": {"name": "veg he 250g rainbow tomato", "qty": "1", "price": "138.0"}
          }
        }
      };

      String result = await data_service.sendReviewedData(data);
      // expect(result)   
      expect(result, '{"status":"success"}');

    });
  });
}