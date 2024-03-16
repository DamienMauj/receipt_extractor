import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> sendData(String url, Map<String, dynamic> data) async {
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response,
    // then parse the JSON.
    print('Data sent successfully');
    return response.body;
  } else {
    // If the server returns an unsuccessful response code,
    // then throw an exception.
    print('Failed to send data');
    return 'Failed to send data';
  }
}