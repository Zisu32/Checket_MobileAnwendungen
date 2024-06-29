import 'package:flutter/material.dart';
import 'package:app/models/jacketModel.dart';
import 'package:random_string/random_string.dart';

class JacketProvider extends ChangeNotifier {
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

  Jacket? getJacketByQrString(String qrString) {
    try {
      return jacketList.firstWhere((jacket) => jacket.qrString == qrString);
    } catch (e) {
      return null;
    }
  }

  void updateJacketStatus(String qrString, Status newStatus) {
    for (var jacket in jacketList) {
      if (jacket.qrString == qrString) {
        jacket.status = newStatus;

        String status; // status for backend
        switch (jacket.status){
          case Status.verfuegbar :
            status = "verfuegbar";
          case Status.abgeholt :
            status = "abgeholt";
          case Status.verloren :
            status = "verloren";
        }
        debugPrint('Jacket updated Status: ${jacket.status}');
        notifyListeners();
        break;
      }
    }
  }

  void addJacketToList(int jacketnumber, String imagePath) {
    Jacket jacket = Jacket(
        jacketNumber: jacketNumber - 1,
        status: Status.verfuegbar,
        imagePath: imagePath,
        qrString: qrString);
    jacketList.add(jacket);
    print('Jacket added: Number: ${jacket.jacketNumber}, Status: ${jacket.status}, Image Path: ${jacket.imagePath}');
    notifyListeners();

  }
}
