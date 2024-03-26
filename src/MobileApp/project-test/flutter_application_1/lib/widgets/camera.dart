import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class CameraPopupWidget extends StatefulWidget {
  final Function(XFile) onPictureTaken;

  CameraPopupWidget({Key? key, required this.onPictureTaken}) : super(key: key);

  @override
  _CameraPopupWidgetState createState() => _CameraPopupWidgetState();
}

class _CameraPopupWidgetState extends State<CameraPopupWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      setState(() {
        _controller = CameraController(_cameras![0], ResolutionPreset.max);
        _controller!.initialize().then((_) {
          if (!mounted) return;
          setState(() {});
        });
      });
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
        widget.onPictureTaken(file);
      } catch (e) {
        print(e);  // Handle errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: CameraPreview(_controller!),
        ),
        ElevatedButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.camera),
          label: Text('Capture'),
        ),
      ],
    );
  }
}
