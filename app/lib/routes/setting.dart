import 'package:flutter/material.dart';
import 'package:app/routes/footer_menu.dart';

class SettingPage extends StatelessWidget{
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(3),
      body: Center(
        child: ElevatedButton(
          onPressed: () {

          },
          child: const Text('SettingPage'),
        )
      )
    );
  }
}