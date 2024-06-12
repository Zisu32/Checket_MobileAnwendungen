import 'package:flutter/material.dart';
import 'package:app/routes/camera.dart';
import 'package:app/routes/list.dart';
import 'package:app/routes/scanner.dart';
import 'package:app/routes/setting.dart';
import 'package:app/routes/login.dart';
import 'package:app/routes/registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      // Here routes for standard navigation
      routes: {
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/scanner': (context) => const ScannerPage(),
        '/list': (context) => const ListPage(),
        '/setting': (context) => const SettingPage(),
      },
      onGenerateRoute: (settings) {
        // Here routes that need to pass arguments
        if (settings.name == '/camera') {
          final initialPictureCounter = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => CameraPage(initialPictureCounter: initialPictureCounter),
          );
        }
        return null; // Return null for any routes not handled above
      },
    );
  }
}
