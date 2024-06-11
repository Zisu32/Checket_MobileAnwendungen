import 'package:flutter/material.dart';
import 'dart:io';
import 'package:app/routes/footer_menu.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 8,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.deepPurpleAccent,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    controller?.resumeCamera(); // Resume the camera
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('abgeholt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[400],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        controller.pauseCamera(); // Pause the camera
        showDialog<void>(
          context: context,
          barrierDismissible: false, // User must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              title: Center(
                child: SizedBox(
                  width: 250,
                  height: 400,
                  child: Text(
                    result != null ? '${result!.code}' : '', //show QR-Scanned Number
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 100,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              actions: <Widget>[
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
          },
        );
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose(); // Properly dispose of the controller
    super.dispose();
  }
}
