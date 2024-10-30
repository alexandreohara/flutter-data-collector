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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)
              .copyWith(surface: Colors.white),
          fontFamily: 'Roboto',
          textTheme: textTheme,
        ),
        initialRoute: '/identification',
        onGenerateRoute: routes,
      ),
    );
  }
}
