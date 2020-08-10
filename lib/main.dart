import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/fonts.dart';
import 'package:data_collector/models/Item.dart';
import 'package:data_collector/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Item>.value(
      value: Item(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: COLOR_PRIMARY,
          errorColor: COLOR_ALERT_RED,
          fontFamily: 'Roboto',
          textTheme: textTheme,
        ),
        initialRoute: '/',
        onGenerateRoute: routes,
      ),
    );
  }
}
