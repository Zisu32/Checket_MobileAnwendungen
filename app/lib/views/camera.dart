import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool _isFlashOn = false; // State to track flashlight status, default to off

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      controller = CameraController(cameras![0], ResolutionPreset.medium);
      await controller!.initialize().then((_) {
        if (mounted) {
          setState(() {
            controller!.setFlashMode(FlashMode.off); // Ensure the flashlight is off when initializing
          });
        }
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Toggle flashlight function
  void _toggleFlashlight() {
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    controller!.setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 300),  // Adds top padding to move the CameraPreview down
          child: controller != null && controller!.value.isInitialized
              ? SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: 350,
              child: CameraPreview(controller!)
          )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 105),  // Additional elevation for the action buttons
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              onPressed: () {
                // Action for taking a photo
              },
              child: const Icon(Icons.add, color: Colors.white, size: 30),
              backgroundColor: Colors.deepPurple,
            ),
            FloatingActionButton(
              onPressed: () {
                // Action for taking a photo
              },
              child: const Icon(Icons.album_outlined, color: Colors.white, size: 30),
              backgroundColor: Colors.deepPurple,
            ),
            FloatingActionButton(
              onPressed: _toggleFlashlight,
              child: Icon(
                  _isFlashOn ? Icons.flashlight_on : Icons.flashlight_off,
                  color: Colors.white,
                  size: 30
              ),
              backgroundColor: _isFlashOn ? Colors.deepPurple : Colors.white10,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.deepPurple,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt, color: Colors.white, size: 40),
            ],
          ),
        ),
      ),
    );
  }
}
