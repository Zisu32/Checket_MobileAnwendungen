import 'package:app/provider/jacketProvider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
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
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser(BuildContext context) async {
    JacketProvider jacketProvider =
        Provider.of<JacketProvider>(context, listen: false);

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Benutzername und Passwort eintragen')),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    // Backend Request
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
      bool jacketsExists = await jacketProvider.getJacktesFromDB();
      if (jacketsExists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[850],
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Daten bereits vorhanden. Vorgehensweise wählen.',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<JacketProvider>(context, listen: false).clearJacktesFromDB();
                        Navigator.of(context).pop();
                        Navigator.popAndPushNamed(context, "/camera");
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent[400],
                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 30),
                      ),
                      child: const Text('neue Schicht starten'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.popAndPushNamed(context, "/camera");
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.deepPurpleAccent[400],
                        padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 30),
                      ),
                      child: const Text('alte Schicht laden'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      } else {
        Navigator.popAndPushNamed(context, "/camera");
      }
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getSavedImagePath(),
      builder: (context, snapshot) {
        Widget imageWidget = SizedBox(
            height: 350,
            child: snapshot.hasData && File(snapshot.data!).existsSync()
                ? Image.file(File(snapshot.data!), fit: BoxFit.cover)
                : const Placeholder(
                    fallbackHeight: 300, fallbackWidth: double.infinity));
        return Scaffold(
          backgroundColor: Colors.grey[850],
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    imageWidget,
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Benutzername',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person,
                          color: _usernameFocusNode.hasFocus
                              ? Colors.deepPurpleAccent[400]
                              : Colors.grey[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurpleAccent[400]!, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Passwort',
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: _passwordFocusNode.hasFocus
                              ? Colors.deepPurpleAccent[400]
                              : Colors.grey[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.deepPurpleAccent[400]!, width: 2.0),
                        ),
                      ),
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
