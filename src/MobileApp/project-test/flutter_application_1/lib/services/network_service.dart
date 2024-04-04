import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_application_1/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/globals.dart' as globals;



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

  Future<void> sendPicture(BuildContext context, XFile? _imageFile, String endpoint) async {
    if (_imageFile == null) return ;

    // try {
      final mimeTypeData = mime.lookupMimeType(_imageFile!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      request.fields['user_id'] = globals.user_id; // Add the user_id field

      request.files.add(await http.MultipartFile.fromPath(
        'file', // This depends on your API endpoint's field name
        _imageFile!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Picture uploaded');
        showPopup(context, "uplaod picture", response.body, false);
        return ;
      } else {
        print('Failed to upload picture');
        return ;
      }
    // } catch (e) {
    //   print(e.toString());
    //   return ;
    // }
  }

  // Function to get data from the server has a dictionary
  Future<Map<String, dynamic>> getData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      print('Data received successfully');
      // print("data: ${response.body}");

      // put the list of dictionary into one data dictionary
      final List<dynamic> dataList = jsonDecode(response.body);
      final Map<String, dynamic> data = {};
      for (var item in dataList) {
        if (item is Map<String, dynamic>) {
          data.addAll(item);
        }
      }
      // return data;



      return data;
    } else {
      // If the server returns an unsuccessful response code,
      // then throw an exception.
      print('Failed to receive data');
      return {};
    }
  }