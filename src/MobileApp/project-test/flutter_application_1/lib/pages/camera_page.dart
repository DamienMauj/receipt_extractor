import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/services/network_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIdx = 0;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();

    if (_cameras!.isNotEmpty) {
      setState(() {
        _controller = CameraController(
          _cameras![_selectedCameraIdx],
          ResolutionPreset.max,
        );
        _controller!.initialize().then((_) {
          if (!mounted) return;
          setState(() {});
        });
      });
    } else {
      print('No camera found');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _takePicture() async {
    if (_controller!.value.isInitialized && !_controller!.value.isTakingPicture) {
      try {
        final file = await _controller!.takePicture();
        setState(() {
          _imageFile = file;
        });
        // Optionally, save the image to the device's gallery or display it in another page
      } catch (e) {
        print(e);  // Handle any errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Take a Picture')),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(_controller!),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: _takePicture,
                  icon: Icon(Icons.camera),
                  label: Text('Capture'),
                ),
                if (_imageFile != null)
                  ElevatedButton.icon(
                    onPressed: () { sendPicture(_imageFile, "http://${dotenv.env['CURRENT_IP']}:8000/uploadPicture/"); },
                    icon: Icon(Icons.upload),
                    label: Text('Upload Picture'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
