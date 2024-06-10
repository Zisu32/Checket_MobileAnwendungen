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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        bool fileExists = false;
        if (snapshot.hasData && snapshot.data != null) {
          fileExists = File(snapshot.data!).existsSync();
        }

        Widget imageWidget = Container(
          height: 250,
          width: double.infinity,
          child: fileExists
              ? Image.file(
            File(snapshot.data!),
            fit: BoxFit.cover,
          )
              : const Placeholder(
            fallbackHeight: 250,
            fallbackWidth: double.infinity,
          ),
        );
        // Check for data and if the file exists
        Widget imageWidget = SizedBox(
            height: 100,
            child: snapshot.hasData && File(snapshot.data!).existsSync()
                ? Image.file(
                    File(
                      snapshot.data!,
                    ),
                    fit: BoxFit.cover,
                  ) // Use BoxFit.cover to make it look better
                : const Placeholder(
                    fallbackHeight: 100, fallbackWidth: double.infinity));

        return Scaffold(
          backgroundColor: Colors.grey[850],
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  imageWidget, // Correct placement inside the Column
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
                      // Simplified login logic
                      Navigator.popAndPushNamed(context, "/camera");
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
          bottomNavigationBar: BottomAppBar(
            color: Colors.deepPurple,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/img/logo-white.png',
                    height: 40,
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
