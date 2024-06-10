import 'package:flutter/cupertino.dart';
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
  bool isPickerActive = false; // Flag to track if picker is active

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
    debugPrint('Showing options');
    return await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () => Navigator.of(context).pop(1),
          ),
          CupertinoActionSheetAction(
            child: const Text('Kamera'),
            onPressed: () => Navigator.of(context).pop(2),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Schließen'),
          onPressed: () => Navigator.of(context).pop(0),
        ),
      ),
    );
  }

  Future<void> pickImage(BuildContext context) async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    }
    if (status.isGranted && !isPickerActive) {
      isPickerActive = true; // Set flag when picker starts
      int source = await showOptions();
      debugPrint('User selected: $source');
      if (source != 0) { // 0 is Cancel, 1 is Gallery, 2 is Camera
        await pickImageFromSource(source == 1 ? ImageSource.gallery : ImageSource.camera);
      }
      isPickerActive = false; // Reset flag when picker ends
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
    }
  }

  Future<void> pickImageFromSource(ImageSource source) async {
    final pickedFile = await imagePickerImplementation.getImage(source: source);
    if (pickedFile != null && pickedFile.path.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('imagePath', pickedFile.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved successfully!')),
      );
      setState(() {
        imagePath = pickedFile.path;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
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
                onPressed: () => pickImage(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurple,
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
                child: const Text('abmelden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}