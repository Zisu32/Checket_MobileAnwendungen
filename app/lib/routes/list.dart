import 'package:flutter/material.dart';
import 'package:app/routes/footer_menu.dart';
import 'package:permission_handler/permission_handler.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String? pdfPath;

  Future<void> downloadReport() async {
    // Check storage permissions
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    if (status.isGranted) {
      // Placeholder for download logic
      // Assume we are simulating a file download
      setState(() {
        pdfPath = "path/to/downloaded/report.pdf";
      });

      // Show a dialog or snackbar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report downloaded to $pdfPath'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Handle the case where the user does not grant permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission is needed to download the report'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (pdfPath != null)
                Text('Last downloaded file: $pdfPath',
                    style: const TextStyle(color: Colors.white)),
              ElevatedButton.icon(
                onPressed: downloadReport,
                icon: const Icon(Icons.download),
                label: const Text('Download Report'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurpleAccent[400],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
