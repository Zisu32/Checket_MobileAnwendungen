import 'dart:io';

import 'package:flutter/material.dart';
import 'package:app/routes/footer_menu.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:app/provider/jacketProvider.dart';
import 'package:app/models/jacketModel.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;
  Jacket? scannedQRStringJacket;

  void _markJacketAsCollected() {
    if (scannedQRStringJacket != null) {
      Provider.of<JacketProvider>(context, listen: false)
          .updateJacketStatus(context, scannedQRStringJacket!.qrString, Status.abgeholt);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
       scannedQRStringJacket = Provider.of<JacketProvider>(context, listen: false).getJacketByQrString(result!.code!);

        if (scannedQRStringJacket != null) {
          controller.stopCamera();
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.grey[850],
                title: Text(
                  '${scannedQRStringJacket!.jacketNumber}',
                  style: const TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 64,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(File(scannedQRStringJacket!.imagePath), fit: BoxFit.fill),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
                actions: <Widget>[
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _markJacketAsCollected();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                            content: Center(child: Text('Abholung erfolgreich')),
                              backgroundColor: Colors.teal,
                              duration: Duration(seconds: 2),
                            ),
                        );
                        controller.resumeCamera();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent[400],
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40),
                      ),
                      child: const Text('abgeholt'),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    });
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
        ],
      ),
    );
  }
}