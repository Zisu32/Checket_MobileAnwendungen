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
  final String ip = utils.getIpAddress();

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
        //Build Request for server
        String uri = 'http://${ip}:3000/updateJacketStatus';
        var url = Uri.parse(uri);
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
    //Build Request for server
    String uri = 'http://${ip}:3000/createJacket';
    var url = Uri.parse(uri);
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

  Status mapStringtoStatus(String status) {
    switch (status) {
      case "verfuegbar" :
        return Status.verfuegbar;
      case "abgeholt" :
        return Status.abgeholt;
      case "verloren" :
        return Status.verloren;
      default :
        return Status.verfuegbar;
    }

  }

  Future<bool> getJacktesFromDB() async {
    String uri = 'http://${ip}:3000/getJacketList';
    var url = Uri.parse(uri);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body)["jackets"];
      if (list.isEmpty){
        return false;
      }
      for (int i = 0; i < list.length; i++) {
        int jacketNumber = list[i]["jacketNumber"];
        String qrString = list[i]["qrString"];
        String imagePath = list[i]["imagePath"];
        Status status = mapStringtoStatus(list[i]["status"]);
        //Build the jacketObject out of the get-Values
        Jacket jacket = Jacket(jacketNumber: jacketNumber, status: status, imagePath: imagePath, qrString: qrString);
        jacketList.add(jacket);
      }
      jacketNumber = list.last["jacketNumber"];
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> clearJacktesFromDB() async {
    String uri = 'http://${ip}:3000/clear';
    var url = Uri.parse(uri);
    var response = await http.delete(url);
    jacketList.clear();
    jacketNumber = 1;
    notifyListeners();
  }
}
