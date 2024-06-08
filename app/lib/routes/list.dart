import 'package:flutter/material.dart';
import 'package:app/routes/footer_menu.dart';

class ListPage extends StatelessWidget{
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(2),
        body: Center(
            child: ElevatedButton(
              onPressed: () {

              },
              child: const Text('ListPage'),
            )
        )
    );
  }
}