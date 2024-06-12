import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'dart:io';
import 'footer_menu.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
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

  Future<void> pickImageFromCamera(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }
    if (cameraStatus.isGranted && !isPickerActive) {
      isPickerActive = true;
      int source = await showOptions();
      debugPrint('User selected: $source');
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

  Future<int> showOptions() async {
    debugPrint('Showing options');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (imagePath != null)
                Image.file(
                  File(imagePath!),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => pickImageFromCamera(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurpleAccent[400],
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.upload),
                label: const Text('Profilbild'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/login");
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurpleAccent[400],
                ),
                child: const Text('abmelden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
