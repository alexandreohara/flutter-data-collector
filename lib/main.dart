import 'package:data_collector/design/fonts.dart';
import 'package:data_collector/models/Item.dart';
import 'package:data_collector/routes.dart';
import 'package:data_collector/service_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => Item()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _getInitialRoute(context),
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
        });
  }

  Future<String> _getInitialRoute(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    final cnpj = prefs.getString('cnpj');
    if (user != null && cnpj != null) {
      Provider.of<Item>(context, listen: false).setUserAndCNPJ(user, cnpj);
      return '/';
    }
    return '/identification';
  }
}
