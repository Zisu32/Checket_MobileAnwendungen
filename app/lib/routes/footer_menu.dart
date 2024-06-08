import 'package:flutter/material.dart';

class CommenFooterMenu {
  late BuildContext context;

  CommenFooterMenu(this.context);

  void goScreen(int newScreen) {
    switch (newScreen) {
      case 0:
        Navigator.popAndPushNamed(context, "/camera");
        break;
      case 1:
        Navigator.popAndPushNamed(context, "/scanner");
        break;
      case 2:
        Navigator.popAndPushNamed(context, "/list");
        break;
      case 3:
        Navigator.popAndPushNamed(context, "/setting");
        break;
    }
  }

  getFooterMenu(int index) {
    var bnb = BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        iconSize: 24.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'Kamera'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scanner'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Liste'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Einstellungen'),
        ],
        onTap: (int index) {
          goScreen(index);
        });
    var theme = Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.deepPurple),
        child: bnb);
    return theme;
  }
}
