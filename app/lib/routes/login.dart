import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Background color of the scaffold
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Placeholder(
                  fallbackHeight: 100, fallbackWidth: double.infinity),
              const SizedBox(height: 50),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Benutzername',
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(
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
                  prefixIcon: Icon(
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
                  bool loginSuccessful = true;   //await checkLogin(); // Implement this function to handle authentication.

                  if (loginSuccessful) {
                    // Navigate to the Camera page if login is successful
                    Navigator.popAndPushNamed(context, "/camera");
                  } else {
                    // Optionally show an error message if login fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Login failed. Please try again."),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('anmelden'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
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
  }
}
