import 'dart:convert';
import 'package:receipt_extractor/classes/receipt_class.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';

class DataService {

  Future<List<Receipt>> fetchReceipts(String user_id) async {
    var url = Uri.parse("http://${dotenv.env['CURRENT_IP']}:8000/getReceipt?user_id=$user_id");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) =>  Receipt.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load receipts : ${response.statusCode} - ${response.body} - ${response.request}');
    }
  }


  Future<Response> sendPicture(XFile? _imageFile, String user_id) async {
    if (_imageFile == null) {
      throw Exception('No image file selected');
    }
    final mimeTypeData = mime.lookupMimeType(_imageFile!.path, headerBytes: [0xFF, 0xD8])?.split('/');
    var request = http.MultipartRequest('POST', Uri.parse("http://${dotenv.env['CURRENT_IP']}:8000/uploadPicture/"));

    request.fields['user_id'] = user_id; 

    request.files.add(await http.MultipartFile.fromPath(
      'file', 
      _imageFile!.path,
      contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }


  Future<String> sendReviewedData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("http://${dotenv.env['CURRENT_IP']}:8000/uploadReceiptData/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Failed to send data';
    }
  }
}