import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:mime/mime.dart' as mime;
import 'package:http_parser/http_parser.dart';


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

  Future<void> sendPicture(XFile? _imageFile, String endpoint) async {
    if (_imageFile == null) return;

    try {
      final mimeTypeData = mime.lookupMimeType(_imageFile!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      request.files.add(await http.MultipartFile.fromPath(
        'file', // This depends on your API endpoint's field name
        _imageFile!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Picture uploaded');
      } else {
        print('Failed to upload picture');
      }
    } catch (e) {
      print(e.toString());
    }
  }