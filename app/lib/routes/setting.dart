import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import '../models/jacketModel.dart';
import '../provider/jacketProvider.dart';
import 'footer_menu.dart';
import 'package:path/path.dart' as path;
import 'package:app/utils/utils.dart' as utils;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  String? pdfPath;
  String? imagePath;
  ImagePickerPlatform imagePickerImplementation = ImagePickerPlatform.instance;
  bool isPickerActive = false;

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPath = prefs.getString('imagePath');
    if (savedPath != null) {
      setState(() {
        imagePath = savedPath;
      });
    }
  }

  Future<int> showOptions() async {
    return await showModalBottomSheet<int>(
          context: context,
          backgroundColor: Colors.grey[850],
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading:
                        const Icon(Icons.photo_library, color: Colors.white),
                    title: const Text('Foto Galerie',
                        style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.of(context).pop(1),
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_alt, color: Colors.white),
                    title: const Text('Kamera',
                        style: TextStyle(color: Colors.white)),
                    onTap: () => Navigator.of(context).pop(2),
                  ),
                ],
              ),
            );
          },
        ) ??
        0; // Handling null (when the user taps outside the bottom sheet)
  }

  Future<void> pickImage(BuildContext context) async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    }
    if (status.isGranted && !isPickerActive) {
      isPickerActive = true;
      int source = await showOptions();
      if (source != 0) {
        await pickImageFromSource(
            source == 1 ? ImageSource.gallery : ImageSource.camera);
      }
      isPickerActive = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Keine Berechtigung')),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Future<void> pickImageFromSource(ImageSource source) async {
    final pickedFile =
        await imagePickerImplementation.getImageFromSource(source: source);
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', pickedFile.path);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Bild hochgeladen')),
        backgroundColor: Colors.teal,
      ));
      setState(() {
        imagePath = pickedFile.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Kein Bild ausgewählt')),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Future<void> downloadReport(pw.Document document) async {
    try {
      var status = await Permission.manageExternalStorage.status;
      if (!status.isGranted) {
        status = await Permission.manageExternalStorage.request();
      }
      if (status.isGranted) {
        final Directory directory = await getApplicationDocumentsDirectory();
        Directory storageDir = Directory(path.join(directory.path, 'Reports'));
        if (!(await storageDir.exists())) {
          await storageDir.create(recursive: true);
        }
        pdfPath = path.join(
            storageDir.path, '${DateTime.now().toString()}_report.pdf');
        final File file = File(pdfPath!);
        await file.writeAsBytes(await document.save());
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Report erstellt')),
          backgroundColor: Colors.teal,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(child: Text('Keine Datei-Berechtigung')),
          backgroundColor: Colors.redAccent,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Fehler beim Downloaden des Berichts')),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Future<pw.Document> generatePdf(List<Jacket> jacketList) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Checket Report ${DateTime.now()}',
                  style: const pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Nummer', 'Status'],
                  ...jacketList.map((jacket) => [
                        jacket.jacketNumber.toString(),
                        utils.mapStatusToString(jacket.status),
                      ]),
                ],
              ),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Center(
            child: const Text(
              'Bestätigung',
              style: TextStyle(color: Colors.white),
            ),
          ),
          content: const Text(
            'Sicher dass Sie die Schicht beenden und einen Report erstellen wollen?',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Column(
              children: [
                Center(
                  child: ElevatedButton(
                    child: const Text('Ja'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 50.0),
                      backgroundColor: Colors.deepPurpleAccent[400],
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      final jacketProvider =
                          Provider.of<JacketProvider>(context, listen: false);
                      final pdf = await generatePdf(jacketProvider.jacketList);
                      await downloadReport(pdf);
                      jacketProvider.clearJacktesFromDB();
                      Navigator.popAndPushNamed(context, "/login");
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    child: const Text('Nein'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurpleAccent[400],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(3),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (imagePath != null)
                  Image.file(
                    File(imagePath!),
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => pickImage(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 85),
                    backgroundColor: Colors.deepPurpleAccent[400],
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.upload),
                  label: const Text('Profilbild'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => _showConfirmationDialog(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.deepPurpleAccent[400],
                  ),
                  child: const Text('abmelden'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
