import 'package:data_collector/components/button.dart';
import 'package:data_collector/design/constants.dart';
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
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
