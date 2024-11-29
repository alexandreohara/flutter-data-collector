import 'package:data_collector/design/fonts.dart';
import 'package:data_collector/models/Item.dart';
import 'package:data_collector/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Item>.value(
      value: Item(),
      child: FutureBuilder<String>(
          future: _getInitialRoute(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return MaterialApp(
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)
                    .copyWith(surface: Colors.white),
                fontFamily: 'Roboto',
                textTheme: textTheme,
              ),
              initialRoute: snapshot.data,
              onGenerateRoute: routes,
            );
          }),
    );
  }

  Future<String> _getInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    final cnpj = prefs.getString('cnpj');
    return (user != null && cnpj != null) ? '/' : '/identification';
  }
}
