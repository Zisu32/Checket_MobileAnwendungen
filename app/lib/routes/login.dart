import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<String?> getSavedImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('imagePath');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getSavedImagePath(),
      builder: (context, snapshot) {
        // Check for data and if the file exists
        Widget imageWidget = snapshot.hasData && File(snapshot.data!).existsSync()
            ? Image.file(File(snapshot.data!), fit: BoxFit.cover) // Use BoxFit.cover to make it look better
            : const Placeholder(fallbackHeight: 100, fallbackWidth: double.infinity);

        return Scaffold(
          backgroundColor: Colors.grey[850],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  imageWidget,  // Show the image if available, or a placeholder if not
                  const SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Benutzername',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: const Icon(
                        Icons.lock,
                        size: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () async {
                      bool loginSuccessful = true;   // Simulated login success

                      if (loginSuccessful) {
                        Navigator.popAndPushNamed(context, "/camera");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Login failed. Please try again."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('anmelden'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/registration");
                    },
                    child: const Text('registrieren'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
