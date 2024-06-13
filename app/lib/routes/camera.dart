import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:app/routes/footer_menu.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraReady = false;
  bool isFlashOn = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isNotEmpty) {
        controller = CameraController(cameras![0], ResolutionPreset.high);
        await controller?.initialize();
        if (!mounted) return;
        setState(() => isCameraReady = true);
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }
    try {
      final XFile file = await controller!.takePicture();
      print('Picture saved to ${file.path}');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'pictureCounter',
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: QrImageView(
                      data: 'qrString',
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                      size: 200.0,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return const Center(
                          child: Text(
                            "Error generating QR code",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.deepPurpleAccent[400],
                    ),
                    child: const Text('schließen'),
                  ),
                ),
              ],
            );
          });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void toggleFlash() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('Error: camera not initialized.');
      return;
    }
    try {
      if (!isFlashOn) {
        await controller!.setFlashMode(FlashMode.torch);
      } else {
        await controller!.setFlashMode(FlashMode.off);
      }
      setState(() {
        isFlashOn = !isFlashOn;
      });
    } catch (e) {
      print('Failed to toggle flash: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (isCameraReady && controller != null)
            Expanded(
              flex: 8,
              child: CameraPreview(controller!),
            ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: takePicture,
                  icon: const Icon(Icons.camera),
                  label: const Text('aufnehmen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[400],
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: toggleFlash,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFlashOn
                        ? Colors.deepPurpleAccent[400]
                        : Colors.white12,
                    foregroundColor: Colors.white,
                  ),
                  child: Icon(
                    isFlashOn ? Icons.flashlight_on : Icons.flashlight_off,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
