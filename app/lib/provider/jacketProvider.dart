import 'package:flutter/material.dart';
import 'package:app/models//jacketModel.dart';
import 'package:random_string/random_string.dart';

class Jacketprovider extends ChangeNotifier {
  int jacketNumber = 1;
  List<Jacket> jacketList = [];
  late String qrString;

  int getJacketCounter() {
    int counter = jacketNumber;
    jacketNumber++;
    return counter;
  }

  String getQrString(){
    qrString =  randomAlphaNumeric(20);
    return qrString;
  }

  void addJacketToList(int jacketnumber, String imagePath) {
    Jacket jacket = Jacket(
        jacketNumber: jacketNumber,
        status: Status.verfuegbar,
        imagePath: imagePath,
        qrString: qrString);
    jacketList.add(jacket);
    notifyListeners();
  }
}
