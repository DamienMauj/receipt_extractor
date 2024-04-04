import 'dart:convert';
import 'package:flutter_application_1/classes/receipt_class.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataService {
  Future<List<Receipt>> fetchReceipts(String user_id) async {
    var url = Uri.parse("http://${dotenv.env['CURRENT_IP']}:8000/getReceipt?user_id=$user_id");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      // print("data: $data");
      return data.map((json) => Receipt.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load receipts');
    }
  }
}