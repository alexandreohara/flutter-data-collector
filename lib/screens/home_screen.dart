import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:data_collector/components/alert_modal.dart';
import 'package:data_collector/components/button.dart';
import 'package:data_collector/database_helper.dart';
import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                'Demétrio Cokinos',
                style: theme.textTheme.headline6.copyWith(color: COLOR_WHITE),
              ),
              accountEmail: Text('CNPJ: 12.123.123/213-23'),
            ),
            ListTile(
              title: Text('Editar usuário base'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Ver itens registrados'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/test-db');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: SPACING_48),
              child: Image.asset(
                'lib/assets/images/axxia-logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: SPACING_32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SPACING_16),
              child: PrimaryButton(
                text: 'Coletar dados',
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ),
            SizedBox(
              height: SPACING_32,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SPACING_16),
              child: SecondaryButton(
                text: 'Carregar arquivo .csv',
                onPressed: () async {
                  _showDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertModal(
          title: Center(
            child: Icon(
              Icons.warning,
              color: COLOR_ALERT_YELLOW,
              size: 72,
            ),
          ),
          content:
              'Os dados devem ser carregados apenas na primeira vez. Deseja fazer isso?',
          onSubmit: () async {
            File file = await FilePicker.getFile(
              type: FileType.custom,
              allowedExtensions: ['csv'],
            );
            List<List<dynamic>> csv = await file
                .openRead()
                .transform(utf8.decoder)
                .transform(CsvToListConverter(
                  fieldDelimiter: ';',
                  textDelimiter: '"',
                  textEndDelimiter: '"',
                ))
                .toList();
            await _insert(csv);
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  Future<void> _insert(List<List<dynamic>> csv) async {
    final dbHelper = DatabaseHelper.instance;
    csv.removeAt(0);
    csv.forEach((row) async {
      await dbHelper.insert({
        DatabaseHelper.serialNumber: row[0],
        DatabaseHelper.name: row[1],
        DatabaseHelper.supplier: row[2],
        DatabaseHelper.model: row[3],
        DatabaseHelper.type: row[4],
        DatabaseHelper.description: row[5],
      });
    });
  }
}
