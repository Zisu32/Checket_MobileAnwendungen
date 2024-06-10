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
  int pictureCounter = 0;  // To keep track of pictures taken

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras!.isNotEmpty) {
        controller = CameraController(cameras![0], ResolutionPreset.high);
        controller!.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            isCameraReady = true;
          });
        }).catchError((err) {
          print('Error initializing camera: $err');
        });
      }
    }).catchError((err) {
      print('Error fetching cameras: $err');
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Background color of the scaffold
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
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: toggleFlash,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFlashOn ? Colors.deepPurple : Colors.white12,
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

  Future<void> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }
    try {
      final XFile file = await controller!.takePicture();
      pictureCounter++;  // Increment the counter whenever a picture is taken
      print('Picture saved to ${file.path}');

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[850], // Background color of the AlertDialog
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$pictureCounter',
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                   SizedBox(
                    width: 250,
                    height: 250,
                    child: QrImageView(
                      data: 'Picture #: $pictureCounter, Path: ${file.path}',
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
                      size: 200.0,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return const Center(
                          child: Text(
                            "Error generating QR code",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white), // Error text color
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
                      backgroundColor: Colors.deepPurple, // Text color of the button
                    ),
                    child: const Text('schließen'),
                  ),
                ),
              ],
            );
          }
      );
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  void toggleFlash() {
    if (!isFlashOn) {
      controller?.setFlashMode(FlashMode.torch);
    } else {
      controller?.setFlashMode(FlashMode.off);
    }
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }
}
