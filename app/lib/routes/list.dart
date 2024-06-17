import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/jacketModel.dart';
import 'package:app/routes/footer_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/provider/jacketProvider.dart';

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
      setState(() {
        pdfPath = "path/to/downloaded/report.pdf";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Report erstellt')),
          backgroundColor: Colors.teal,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text('Keine Datei-Berechtigung')),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> importSession() async {

  }

  Color getStatusColor(Status status) {
    switch (status) {
      case Status.verfuegbar:
        return Colors.teal;
      case Status.abgeholt:
        return Colors.grey;
      case Status.verloren:
        return Colors.redAccent;
      default:
        return Colors.black;
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
            children: <Widget>[
              Expanded(
                child: Consumer<JacketProvider>(
                  builder: (context, jacketProvider, child) {
                    return ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor: MaterialStateProperty.all(Colors.grey[700]),
                        thickness: MaterialStateProperty.all(3),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(right: 20.0),
                          itemCount: jacketProvider.jacketList.length,
                          itemBuilder: (context, index) {
                            Jacket jacket = jacketProvider.jacketList[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: getStatusColor(jacket.status),
                                  radius: 10,
                                ),
                                title: Text(
                                  '${jacket.jacketNumber}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: CircleAvatar(
                                  backgroundColor: Colors.deepPurpleAccent[400],
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: downloadReport,
                      icon: const Icon(Icons.download),
                      label: const Text('Report'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.deepPurpleAccent[400],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: importSession,
                      icon: const Icon(Icons.upload),
                      label: const Text('Import'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.deepPurpleAccent[400],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
