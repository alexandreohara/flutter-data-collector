import 'dart:io';

import 'package:data_collector/components/alert_modal.dart';
import 'package:data_collector/components/button.dart';
import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Navigator.pushNamed(context, '/identification');
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
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
