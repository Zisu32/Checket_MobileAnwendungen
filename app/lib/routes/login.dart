import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    // Check if the username or password fields are empty
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Benutzername und Passwort eintragen')),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }
    // Proceed with login if both fields are filled
    var url = Uri.parse('http://10.0.2.2:3000/login');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text
      }),
    );

    if (response.statusCode == 200) {
      Navigator.popAndPushNamed(context, "/camera");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Logindaten prüfen')),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Future<String?> getSavedImagePath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('imagePath');
  }

  //ImageLoader
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
        //Display ImageBox
        Widget imageWidget = SizedBox(
            height: 300,
            child: snapshot.hasData && fileExists
                ? Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                  )
                : const Placeholder(
                    fallbackHeight: 300, fallbackWidth: double.infinity));

        return Scaffold(
          backgroundColor: Colors.grey[850],
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  imageWidget,
                  const SizedBox(height: 50),
                  TextFormField(
                    controller: _usernameController,
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
                    controller: _passwordController,
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
                    onPressed: () => loginUser(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.deepPurpleAccent[400],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('anmelden'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, "/registration");
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurpleAccent[400],
                    ),
                    child: const Text('registrieren'),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.deepPurpleAccent[400],
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
