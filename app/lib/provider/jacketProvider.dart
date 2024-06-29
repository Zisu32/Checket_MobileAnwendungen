import 'package:flutter/material.dart';
import 'package:app/models/jacketModel.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/utils/utils.dart' as utils;

class JacketProvider extends ChangeNotifier {
  int jacketNumber = 1;
  List<Jacket> jacketList = [];
  late String qrString;

  int getJacketCounter() {
    int counter = jacketNumber;
    jacketNumber++;
    return counter;
  }

  String getQrString() {
    qrString = randomAlphaNumeric(20);
    return qrString;
  }

  Jacket? getJacketByQrString(String qrString) {
    try {
      return jacketList.firstWhere((jacket) => jacket.qrString == qrString);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateJacketStatus(
      BuildContext context, String qrString, Status newStatus) async {
    for (var jacket in jacketList) {
      if (jacket.qrString == qrString) {
        jacket.status = newStatus;
        utils.mapStatusToString(jacket.status);
        String status = utils.mapStatusToString(newStatus);
        //Build Request for backend
        var url = Uri.parse('http://10.0.2.2:3000/updateJacketStatus');
        var response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json
              .encode({'jacketNumber': jacket.jacketNumber, 'status': status}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Status Update erfolgreich')),
            backgroundColor: Colors.teal,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Status Update fehlgeschlagen')),
            backgroundColor: Colors.redAccent,
          ));
        }

        debugPrint('Jacket updated Status: ${jacket.status}');
        notifyListeners();
        break;
      }
    }
  }

  Future<void> addJacketToList(
      BuildContext context, int jacketnumber, String imagePath) async {
    Jacket jacket = Jacket(
        jacketNumber: jacketNumber - 1,
        status: Status.verfuegbar,
        imagePath: imagePath,
        qrString: qrString);
    jacketList.add(jacket);
    //Build Request for backend
    var url = Uri.parse('http://10.0.2.2:3000/createJacket');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'jacketNumber': jacket.jacketNumber,
        'qrString': jacket.qrString,
        'imagePath': jacket.imagePath
      }),
    );

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Center(child: Text('Hinzufügen fehlgeschlagen')),
        backgroundColor: Colors.redAccent,
      ));
    }

    debugPrint(
        'Jacket added: Number: ${jacket.jacketNumber}, Status: ${jacket.status}, Image Path: ${jacket.imagePath}');
    notifyListeners();
  }
}
