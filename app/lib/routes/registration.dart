import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/utils/utils.dart' as utils;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _repeatPasswordFocusNode = FocusNode();
  final String ip = utils.getIpAddress();

  @override
  void initState() {
    super.initState();
    _usernameFocusNode.addListener(() { setState(() {}); });
    _passwordFocusNode.addListener(() { setState(() {}); });
    _repeatPasswordFocusNode.addListener(() { setState(() {}); });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> registerUser(BuildContext context) async {
    if (_passwordController.text != _repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Passwörter nicht identisch')),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    String uri = 'http://${ip}:3000/registration';
    var url = Uri.parse(uri);
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Registrierung erfolgreich')),
        backgroundColor: Colors.teal,
      ));
      Navigator.popAndPushNamed(context, "/login"); // Navigate immediately.
    } else if (response.statusCode == 409) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Benutzername schon vergeben')),
        backgroundColor: Colors.redAccent,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Registrierung fehlgeschlagen')),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                focusNode: _usernameFocusNode,
                decoration: InputDecoration(
                  hintText: 'Benutzername',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.person,
                    color: _usernameFocusNode.hasFocus ? Colors.deepPurpleAccent[400] : Colors.grey[700],
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent[400]!, width: 2.0),
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
                    color: _passwordFocusNode.hasFocus ? Colors.deepPurpleAccent[400] : Colors.grey[700],
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent[400]!, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _repeatPasswordController,
                focusNode: _repeatPasswordFocusNode,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Passwort wiederholen',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: _repeatPasswordFocusNode.hasFocus ? Colors.deepPurpleAccent[400] : Colors.grey[700],
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurpleAccent[400]!, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => registerUser(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurpleAccent[400],
                  foregroundColor: Colors.white,
                ),
                child: const Text('registrieren'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, "/login");
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurpleAccent[400],
                ),
                child: const Text('anmelden'),
              )
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
  }
}
