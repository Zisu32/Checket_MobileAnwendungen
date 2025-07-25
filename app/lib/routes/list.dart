import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/jacketModel.dart';
import 'package:app/routes/footer_menu.dart';
import 'package:app/provider/jacketProvider.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool _showOnlyVerfuegbar = false;
  String _searchQuery = '';

  Color mapStatusColor(Status status) {
    switch (status) {
      case Status.verfuegbar:
        return Colors.teal;
      case Status.abgeholt:
        return Colors.grey;
      case Status.verloren:
        return Colors.redAccent;
      default:
        return Colors.black;
    }
  }

  Future<void> showEditDialog(Jacket jacket) async {
    final jacketProvider = Provider.of<JacketProvider>(context, listen: false);
    Status? newStatus = jacket.status;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${jacket.jacketNumber}',
                    style: const TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 250,
                      child: Image.file(
                        File(jacket.imagePath),
                        fit: BoxFit.fill,
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: mapStatusColor(newStatus!),
                        radius: 10,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Status',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<Status>(
                        value: newStatus,
                        dropdownColor: Colors.grey[850],
                        style: const TextStyle(color: Colors.white),
                        onChanged: (Status? newValue) {
                          setState(() {
                            newStatus = newValue!;
                          });
                        },
                        items: Status.values
                            .map<DropdownMenuItem<Status>>((Status value) {
                          return DropdownMenuItem<Status>(
                            value: value,
                            child: Text(value.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    jacketProvider.updateJacketStatus(
                        context, jacket.qrString, newStatus!);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurpleAccent[400],
                  ),
                  child: const Text('speichern'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('schließen',
                      style: TextStyle(color: Colors.deepPurpleAccent)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: CommenFooterMenu(context).getFooterMenu(2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Nummer suchen',
                        hintStyle: const TextStyle(color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black54),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 20,
                        ),
                      ),
                      style: const TextStyle(color: Colors.black54),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showOnlyVerfuegbar = !_showOnlyVerfuegbar;
                      });
                    },
                    icon: const Icon(Icons.filter_list),
                    label: Text(
                        _showOnlyVerfuegbar ? 'Verfügbar' : '   Alle        '),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent[400],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<JacketProvider>(
                  builder: (context, jacketProvider, child) {
                    var jacketList = _showOnlyVerfuegbar
                        ? jacketProvider.jacketList
                            .where(
                                (jacket) => jacket.status == Status.verfuegbar)
                            .toList()
                        : jacketProvider.jacketList;

                    if (_searchQuery.isNotEmpty) {
                      jacketList = jacketList
                          .where((jacket) => jacket.jacketNumber
                              .toString()
                              .contains(_searchQuery))
                          .toList();
                    }

                    return ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor: WidgetStateProperty.all(Colors.grey[700]),
                        thickness: WidgetStateProperty.all(3),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(right: 20.0),
                          itemCount: jacketList.length,
                          itemBuilder: (context, index) {
                            Jacket jacket = jacketList[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      mapStatusColor(jacket.status),
                                  radius: 10,
                                ),
                                title: Text(
                                  '${jacket.jacketNumber}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    showEditDialog(jacket);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.deepPurpleAccent[400],
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
