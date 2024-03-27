import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GalleryPopupWidget extends StatefulWidget {
  final Function(XFile) onImageSelected;

  GalleryPopupWidget({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  _GalleryPopupWidgetState createState() => _GalleryPopupWidgetState();
}

class _GalleryPopupWidgetState extends State<GalleryPopupWidget> {
  final ImagePicker _picker = ImagePicker();

  void _pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        widget.onImageSelected(pickedFile);
      }
    } catch (e) {
      print('Failed to pick image: $e');  // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.photo_library),
          title: Text('Select from Gallery'),
          onTap: () {
            _pickImageFromGallery();
            Navigator.of(context).pop(); // Close the popup after selection
          },
        ),
      ],
    );
  }
}
