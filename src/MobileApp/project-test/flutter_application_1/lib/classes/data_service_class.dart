import 'dart:convert';
import 'package:flutter_application_1/classes/receipt_class.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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
      // print("data: $data");
      return data.map((json) =>  Receipt.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load receipts');
    }
  }

  Future<Response> sendPicture(XFile? _imageFile, String user_id) async {
    if (_imageFile == null) {
      throw Exception('No image file selected');
    }

    // try {
      final mimeTypeData = mime.lookupMimeType(_imageFile!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      var request = http.MultipartRequest('POST', Uri.parse("http://${dotenv.env['CURRENT_IP']}:8000/uploadPicture/"));

      request.fields['user_id'] = user_id; // Add the user_id field

      request.files.add(await http.MultipartFile.fromPath(
        'file', // This depends on your API endpoint's field name
        _imageFile!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response;

      // if (response.statusCode == 200) {
      //   print('Picture uploaded');
      //   showPopup(context, "uplaod picture", response.body, false);
      //   return ;
      // } else {
      //   print('Failed to upload picture');
      //   return ;
      // }
    // } catch (e) {
    //   print(e.toString());
    //   return ;
    // }
  }


}