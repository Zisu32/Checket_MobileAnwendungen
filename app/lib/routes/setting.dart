import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/routes/footer_menu.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'dart:io';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  String? imagePath;
  ImagePickerPlatform imagePickerImplementation = ImagePickerPlatform.instance;
  bool isPickerActive = false; // Add this flag to track if picker is active

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
    int selection = 0;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () async {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              selection = await getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () async {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              selection = await getImageFromCamera();
            },
          ),
        ],
      ),
    );
    return selection;
  }

  Future<int> getImageFromGallery() async {
    final pickedFile = await imagePickerImplementation.getImageFromSource(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      if (pickedFile.path != "") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('imagePath', pickedFile.path);
        // debugPrint('Image saved to shared preferences $imagePath');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
      setState(() {
        imagePath = pickedFile.path;
        debugPrint('Image path: $imagePath');
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No image selected')));
    }
    return 1;
  }

//Image Picker function to get image from camera
  Future<int> getImageFromCamera() async {
    debugPrint('Getting image from camera');
    final pickedFile = await imagePickerImplementation.getImageFromSource(
        source: ImageSource.camera);

    if (pickedFile != null) {
      if (pickedFile.path != "") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('imagePath', pickedFile.path);
        // debugPrint('Image saved to shared preferences $imagePath');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
      setState(() {
        imagePath = pickedFile.path;
        debugPrint('Image path: $imagePath');
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No image selected')));
    }
    return 2;
  }

  Future<void> pickImage(BuildContext context) async {
    debugPrint('Pick image');
    // Check and request storage permission
    await Permission.photos.request();
    var status = await Permission.photos.status;

    debugPrint('Storage permission status: $status');
    if (!status.isGranted) {
      await Permission.photos.request();
    }
    if (!isPickerActive) {
      if (imagePickerImplementation is ImagePickerAndroid) {
        (imagePickerImplementation as ImagePickerAndroid)
            .useAndroidPhotoPicker = true;
      }
    }
    int x = await showOptions();
    debugPrint('User selected: $x');

    // if (await Permission.photos.isGranted) {
    //   final ImagePicker picker = ImagePicker();

    //   final XFile? image =
    //       await picker.pickImage(source: ImageSource.values[1]);

    // if (imagePath != "" && imagePath != null) {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   await prefs.setString('imagePath', imagePath!);
    //   // debugPrint('Image saved to shared preferences $imagePath');

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Image saved successfully!')),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('No image selected')),
    //   );
    // }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Storage permission denied')),
    //   );
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
                  height: 300, // Fixed height for image
                  fit: BoxFit.cover, // Cover the area without distortion
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
