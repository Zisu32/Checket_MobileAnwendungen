import 'package:flutter/material.dart';

class CommenFooterMenu {
  late BuildContext context;
  int initialPictureCounter;

  CommenFooterMenu(this.context, {this.initialPictureCounter = 0});

  void goScreen(int newScreen) {
    switch (newScreen) {
      case 0:
        Navigator.popAndPushNamed(context, "/camera", arguments: initialPictureCounter);
        break;        break;
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

  Widget _iconWithIndicator(Widget icon, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 2,
          width: 24,
          color: isActive ? Colors.deepPurpleAccent[100] : Colors.transparent,
        ),
        const SizedBox(height: 6), // Space between indicator and icon
        icon,
      ],
    );
  }

  getFooterMenu(int index) {
    var bnb = BottomNavigationBar(
        currentIndex: index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.deepPurple[900],
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        iconSize: 24.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: _iconWithIndicator(const Icon(Icons.camera_alt), index == 0),
              label: 'Kamera'),
          BottomNavigationBarItem(
              icon: _iconWithIndicator(const Icon(Icons.qr_code_scanner), index == 1),
              label: 'Scanner'),
          BottomNavigationBarItem(
              icon: _iconWithIndicator(const Icon(Icons.list), index == 2),
              label: 'Liste'),
          BottomNavigationBarItem(
              icon: _iconWithIndicator(const Icon(Icons.settings), index == 3),
              label: 'Einstellungen'),
        ],
        onTap: (int index) {
          goScreen(index);
        });
    var theme = Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.deepPurpleAccent[400]),
        child: bnb);
    return theme;
  }
}
