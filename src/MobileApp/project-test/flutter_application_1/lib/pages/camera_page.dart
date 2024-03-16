import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _selectedCameraIdx = 0;

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

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text('Take a Picture')),
      body: CameraPreview(_controller!),
    );
  }
}
