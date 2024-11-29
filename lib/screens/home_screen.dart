import 'package:data_collector/components/button.dart';
import 'package:data_collector/database_helper.dart';
import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          padding: EdgeInsets.zero,
          children: <Widget>[
            Consumer<Item>(
                builder: (BuildContext context, Item item, Widget? child) {
              return FutureBuilder(
                  future: _loadUserData(context, item),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    return UserAccountsDrawerHeader(
                      accountName: Text(
                        item.user ?? "user",
                        style: theme.textTheme.titleLarge!
                            .copyWith(color: COLOR_WHITE),
                      ),
                      accountEmail: Text(item.cnpj ?? "cnpj"),
                    );
                  });
            }),
            ListTile(
              title: Text('Alterar Nome e CNPJ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit-identification');
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
                  Navigator.pushNamed(context, '/form');
                },
              ),
            ),
            SizedBox(
              height: SPACING_32,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserData(BuildContext context, Item item) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    final cnpj = prefs.getString('cnpj');
    item.setUserAndCNPJ(user!, cnpj!);
  }

  Future<void> _insert(List<List<dynamic>> csv) async {
    final dbHelper = DatabaseHelper.instance;
    csv.removeAt(0);
    csv.forEach((row) async {
      await dbHelper.insert({
        DatabaseHelper.name: row[1],
        DatabaseHelper.supplier: row[2],
        DatabaseHelper.model: row[3],
        DatabaseHelper.type: row[4],
        DatabaseHelper.description: row[5],
      });
    });
  }
}
