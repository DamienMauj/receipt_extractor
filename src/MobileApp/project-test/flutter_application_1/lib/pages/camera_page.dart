import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/services/network_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/widgets/camera.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/widgets/camera_roll.dart';
import 'package:flutter_application_1/widgets/navigation_bar.dart';



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
      builder: (BuildContext context) {
        return CameraPopupWidget(
          onPictureTaken: (XFile file) {
            setState(() {
              _imageFile = file;
            });
            Navigator.pop(context);
          },
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
      await sendPicture(context, _imageFile, "http://${dotenv.env['CURRENT_IP']}:8000/uploadPicture/");
      // Handle response or any other logic here
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
      appBar: AppBar(title: Text('Take a Picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: _imageFile == null
                  ? Center(child: Text('No image selected'))
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
                    child: Text('Open Camera'),
                  ),
                  ElevatedButton(
                    onPressed: _pickImageFromGallery,
                    child: Text('Open Gallery'),
                  ),
                  if (_imageFile != null)
                  ElevatedButton.icon(
                    onPressed: _isUploading ? null : _uploadAndSendImage, // Disable button when uploading
                    icon: _isUploading
                        ? SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          )
                        : Icon(Icons.upload),
                    label: Text('Upload Picture'),
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
