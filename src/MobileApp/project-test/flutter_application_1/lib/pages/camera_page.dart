import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/services/network_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/widgets/camera.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/widgets/camera_roll.dart';
import 'package:flutter_application_1/widgets/navigation_bar.dart';
import 'package:flutter_application_1/classes/data_service_class.dart';
import 'package:flutter_application_1/globals.dart' as globals;
import 'package:flutter_application_1/widgets/popup.dart';



class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;


  void _showCameraPopup() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.8, 
        child: CameraPopupWidget(
          onPictureTaken: (XFile file) {
            setState(() {
              _imageFile = file;
            });
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}
  void _showGalleryPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return GalleryPopupWidget(
        onImageSelected: (XFile file) {
          // Use the file (image) as needed
        },
      );
    },
  );
}

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

    Future<void> _uploadAndSendImage() async {
    setState(() {
      _isUploading = true;
    });
    try {
    Response response = await DataService().sendPicture(_imageFile, globals.user_id);
    if (response.statusCode == 200) {
        print('Picture uploaded');
        showPopup(context, "uplaod picture", response.body, false);
      } else {
        throw Exception('Failed to upload picture');
      }
    } catch (e) {
      // Handle error here
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('Camera Page'),
      appBar: AppBar(title: Text('Take a Picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _imageFile == null
                  ? const Center(
                      child: Text(
                        "No image selected.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                          : AspectRatio(
                      aspectRatio: 1, // You can adjust this ratio according to your needs
                      child: Image.file(File(_imageFile!.path), fit: BoxFit.cover),
                    ),
            ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _showCameraPopup,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 60), // Makes the button square and larger
                      shape: const RoundedRectangleBorder( // Makes the button edges square
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.all(16), // Optional: add padding to increase the size
                    ),
                    child: const Text('Open Camera'),
                  ),
                  ElevatedButton(
                    onPressed: _pickImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 60), // Makes the button square and larger
                      shape: const RoundedRectangleBorder( // Makes the button edges square
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.all(16), // Optional: add padding to increase the size
                    ),
                    child: const Text('Open Gallery'),
                  ),
                  if (_imageFile != null)
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _uploadAndSendImage, // Disable button when uploading
                    icon: _isUploading
                        ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Icon(Icons.upload),
                    label: const Text('Extract'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(120, 60), // Makes the button square and larger
                      shape: const RoundedRectangleBorder( // Makes the button edges square
                        borderRadius: BorderRadius.zero,
                      ),
                      padding: const EdgeInsets.all(16), // Optional: add padding to increase the size
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(selectedIndex: 1),
    );
  }
  



}