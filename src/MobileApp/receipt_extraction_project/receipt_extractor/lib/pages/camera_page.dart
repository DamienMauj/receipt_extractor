import 'package:flutter/material.dart';
import 'package:receipt_extractor/widgets/camera.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:receipt_extractor/widgets/camera_roll.dart';
import 'package:receipt_extractor/widgets/navigation_bar.dart';
import 'package:receipt_extractor/classes/data_service_class.dart';
import 'package:receipt_extractor/globals.dart' as globals;
import 'package:receipt_extractor/widgets/popup.dart';

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
  double _imageAspectRatio = 1; // Default aspect ratio
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialImageFile != null) {
      _imageFile = widget.initialImageFile;
    }
  }

  Future<void> _setImageFile(XFile file) async {
    final decodedImage = await decodeImageFromList(await file.readAsBytes());
    setState(() {
      _imageFile = file;
      _imageAspectRatio = decodedImage.width / decodedImage.height;
    });
  }

  void _showCameraPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          key: const Key('Camera Popup'),
          heightFactor: 0.8, 
          child: CameraPopupWidget(
            key: const Key('Camera Popup Widget'),
            onPictureTaken: (XFile file) {
              _setImageFile(file);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await widget.picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _setImageFile(pickedFile);
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
          showPopup(context, "Upload Picture", response.body, false);
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
      key: const Key('Camera Page'),
      appBar: AppBar(title: const Text('Take a Picture')),
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
                      aspectRatio: _imageAspectRatio,
                      child: Image.file(File(_imageFile!.path), fit: BoxFit.contain),
                    ),
            ),
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    key: const Key('Open Camera Button'),
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
                    key: const Key('Open Gallery Button'),
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
                    key: const Key('Extract Button'),
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




