import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/helpers.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:data_collector/service_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IdentificationScreen extends StatefulWidget {
  @override
  _IdentificationScreenState createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode userFocusNode = FocusNode();
  final FocusNode cnpjFocusNode = FocusNode();
  final userController = TextEditingController(text: 'Demetrio');
  final maskedController = MaskedTextController(
      mask: '00.000.000/0000-00', text: '41.684.544/0001-05');

  @override
  void dispose() {
    userController.dispose();
    maskedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var item = Provider.of<Item>(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: SPACING_16),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: SPACING_32,
                  ),
                  Text(
                    'Antes de começar, digite o seu nome e o CNPJ do cliente.',
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  Text('O CNPJ será o nome da pasta dentro do Google Drive',
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    validator: (value) => requiredValidator(value),
                    focusNode: userFocusNode,
                    controller: userController,
                    labelText: 'Nome',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    validator: (value) {
                      return multiplesValidators(
                          value, [requiredValidator, cnpjValidator]);
                    },
                    focusNode: cnpjFocusNode,
                    labelText: 'CNPJ',
                    hintText: '__.___.___/____-__',
                    isValid: true,
                    controller: maskedController,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: SPACING_8,
                  ),
                  Text(
                    'Você poderá alterar essas informações futuramente.',
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: SPACING_48,
                  ),
                  PrimaryButton(
                    text: 'Coletar dados',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _savePreferences(context, item,
                            userController.text, maskedController.text);
                        Navigator.pushNamed(context, '/', arguments: item);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePreferences(
      BuildContext context, Item item, String user, String cnpj) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', user);
      await prefs.setString('cnpj', cnpj);
      final folderId = await Provider.of<AuthService>(context, listen: false)
          .createOrFetchFolder(cnpj, dotenv.env['PARENT_ID']!);
      await prefs.setString('folderId', folderId);
      Provider.of<AuthService>(context, listen: false)
          .createOrFetchSheets(folderId, 'Dados - $cnpj');
      item.setUserAndCNPJ(userController.text, maskedController.text);
    } catch (e) {
      print('Error saving preferences: $e');
    }
  }
}
