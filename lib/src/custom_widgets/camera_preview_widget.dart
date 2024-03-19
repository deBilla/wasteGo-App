import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:wastego/src/home_page_view.dart';

class CameraPreviewWidget extends StatefulWidget {
  final CameraDescription camera;
  final Function(File image) onImageCaptured;

  const CameraPreviewWidget({
    Key? key,
    required this.camera,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  CameraPreviewWidgetState createState() => CameraPreviewWidgetState();
}

class CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing =
      false; // Added state to track if image processing is ongoing
  File? _capturedImage; // File to hold the captured image

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Preview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleCloseButtonPressed,
          ),
        ],
      ),
      body: _capturedImage == null
          ? Stack(
              children: [
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                if (_isProcessing) // Show loader when processing image
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            )
          : Image.file(_capturedImage!),
      floatingActionButton: Container(
        alignment: Alignment.center,
        child: FloatingActionButton(
          onPressed: _capturedImage == null
              ? (_isProcessing ? null : _handleCaptureButtonPressed)
              : _handleResetButtonPressed,
          child: _capturedImage == null
              ? const Icon(Icons.camera)
              : const Icon(Icons.refresh),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _handleCaptureButtonPressed() async {
    setState(() {
      _isProcessing = true; // Start showing loader
    });
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      widget.onImageCaptured(File(image.path));
      setState(() {
        _capturedImage = File(image.path); // Set the captured image
      });
    } catch (e) {
      print('Error taking picture: $e');
    } finally {
      setState(() {
        _isProcessing = false; // Stop showing loader
      });
    }
  }

  void _handleResetButtonPressed() {
    setState(() {
      _capturedImage = null; // Clear the captured image
    });
  }

  void _handleCloseButtonPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePageView(),
      ),
    );
  }
}
