import 'package:flutter/material.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],  // Correct placement of the backgroundColor
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Benutzername'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Passwort'),
                obscureText: true,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Passwort wiederholen'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('registrieren'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurple,  // Changed from 'primary'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
