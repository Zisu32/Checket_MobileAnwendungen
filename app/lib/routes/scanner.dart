import 'package:flutter/material.dart';
import 'package:app/routes/footer_menu.dart';

class ScannerPage extends StatelessWidget{
  const ScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(1),
        body: Center(
            child: ElevatedButton(
              onPressed: () {

              },
              child: const Text('ScannerPage'),
            )
        )
    );
  }
}