import 'package:data_collector/components/button.dart';
import 'package:data_collector/database_helper.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class TestDatabase extends StatelessWidget {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(SPACING_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              PrimaryButton(
                text: 'Inserir',
                onPressed: () {
                  _insert();
                },
              ),
              SizedBox(
                height: SPACING_16,
              ),
              PrimaryButton(
                text: 'Consultar',
                onPressed: () {
                  _queryAll();
                },
              ),
              SizedBox(
                height: SPACING_16,
              ),
              PrimaryButton(
                text: 'Atualizar',
                onPressed: () {
                  _update();
                },
              ),
              SizedBox(
                height: SPACING_16,
              ),
              PrimaryButton(
                text: 'Deletar',
                onPressed: () {
                  _delete();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.user: 'Demetrio',
      DatabaseHelper.cnpj: 12345678901234,
      DatabaseHelper.name: 'Leandro',
      DatabaseHelper.number: 30
    };
    final id = await dbHelper.insert(row);
    print('linha inserida id: $id');
  }

  void _queryAll() async {
    final todasLinhas = await dbHelper.queryAllRows();
    print('Consulta todas as linhas:');
    todasLinhas.forEach((row) => print(row));
  }

  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1,
      DatabaseHelper.user: 'Pedro',
      DatabaseHelper.cnpj: 01230123012301,
      DatabaseHelper.name: 'Ale',
      DatabaseHelper.number: 20
    };
    final linhasAfetadas = await dbHelper.update(row);
    print('atualizadas $linhasAfetadas linha(s)');
  }

  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final linhaDeletada = await dbHelper.delete(id!);
    print('Deletada(s) $linhaDeletada linha(s): linha $id');
  }
}
