import 'package:app/provider/jacketProvider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:app/routes/footer_menu.dart';
import 'package:provider/provider.dart';
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
      int jacketNumber = Provider.of<JacketProvider>(context, listen: false).getJacketCounter();
      String qrString = Provider.of<JacketProvider>(context, listen: false).getQrString();
      Provider.of<JacketProvider>(context, listen: false).addJacketToList(context, jacketNumber, file.path);

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    jacketNumber.toString(),
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: QrImageView(
                      data: qrString,
                      version: QrVersions.auto,
                      backgroundColor: Colors.white,
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
                      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 30),
                    ),
                    child: const Text('hinzufügen'),
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
      body: Stack(
        children: <Widget>[
          if (isCameraReady && controller != null)
            Positioned.fill(
              child: CameraPreview(controller!),
            ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
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
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30),
                  ),
                ),
                ElevatedButton(
                  onPressed: toggleFlash,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFlashOn
                        ? Colors.deepPurpleAccent[400]
                        : Colors.grey[800],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
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