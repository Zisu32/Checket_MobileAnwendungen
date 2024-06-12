import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  Future<void> registerUser(BuildContext context) async {
    if (_passwordController.text != _repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Passwörter nicht identisch')),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    var url = Uri.parse('http://10.0.2.2:3000/registration');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      var snackBar = ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Registrierung erfolgreich')),
        backgroundColor: Colors.teal,
      ));
      await snackBar.closed;
      Navigator.popAndPushNamed(context, "/login");
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
                decoration: const InputDecoration(
                  labelText: 'Benutzername',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.person, size: 20),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Passwort',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.lock, size: 20),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 25),
              TextFormField(
                controller: _repeatPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Passwort wiederholen',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.lock, size: 20),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
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
