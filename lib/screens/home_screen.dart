import 'package:data_collector/components/button.dart';
import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Áxxia Data Collector',
              style: theme.textTheme.headline,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: SPACING_16,
            ),
            PrimaryButton(
              text: 'Coletar dados',
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}
