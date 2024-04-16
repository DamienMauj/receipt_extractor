import 'package:flutter/material.dart';
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
  final ImagePicker picker;
  final DataService dataService;
  final XFile? initialImageFile; // Optional initial image file

  CameraPage({Key? key, ImagePicker? picker, DataService? dataService, this.initialImageFile})
    : this.picker = picker ?? ImagePicker(),
      this.dataService = dataService ?? DataService(),
      super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // If an initial image file is provided, use it
    if (widget.initialImageFile != null) {
      _imageFile = widget.initialImageFile;
    }
  }


  void _showCameraPopup() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        key: Key('Camera Popup'),
        heightFactor: 0.8, 
        child: CameraPopupWidget(
          key: Key('Camera Popup Widget'),
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
        key: Key('Gallery Popup Widget'),
        onImageSelected: (XFile file) {
        },
      );
    },
  );
}

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await widget.picker.pickImage(source: ImageSource.gallery);
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
                    key: Key('No Image Selected Message'),
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
                    key: Key('Open Camera Button'),
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
                    key: Key('Open Gallery Button'),
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
                    key: Key('Extract Button'),
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