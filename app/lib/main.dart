import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/routes/camera.dart';
import 'package:app/routes/list.dart';
import 'package:app/routes/scanner.dart';
import 'package:app/routes/setting.dart';
import 'package:app/routes/login.dart';
import 'package:app/routes/registration.dart';
import 'package:app/provider/jacketProvider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => JacketProvider()),
  ], child: const MyApp()));
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
        '/camera': (context) => const CameraPage(),
        '/scanner': (context) => const ScannerPage(),
        '/list': (context) => const ListPage(),
        '/setting': (context) => const SettingPage(),
      },
    );
  }
}
