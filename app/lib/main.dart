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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/registration': (context) => const RegistrationPage(),
        '/camera': (context) => const CameraPage(),
        '/scanner': (context) => const ScannerPage(),
        '/list': (context) => const ListPage(),
        '/setting': (context) => const SettingPage(),
      },
    );
  }
}
