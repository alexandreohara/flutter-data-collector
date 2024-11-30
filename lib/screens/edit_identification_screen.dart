import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/helpers.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

class EditIdentificationScreen extends StatefulWidget {
  const EditIdentificationScreen();

  @override
  _EditIdentificationScreenState createState() =>
      _EditIdentificationScreenState();
}

class _EditIdentificationScreenState extends State<EditIdentificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode userFocusNode = FocusNode();
  final FocusNode cnpjFocusNode = FocusNode();
  final userController = TextEditingController();
  final maskedController =
      MaskedTextController(mask: '00.000.000/0000-00', text: '');

  _EditIdentificationScreenState();

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
        appBar: AppBar(
          title: Text('Descrição do item'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
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
                    'Digite o seu nome e o CNPJ do cliente',
                    style: theme.textTheme.headlineSmall,
                  ),
                  Text(
                    'Você poderá alterar essas informações futuramente',
                    style: theme.textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    validator: (value) => requiredValidator(value),
                    maxLength: 10,
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
                    height: SPACING_48,
                  ),
                  PrimaryButton(
                    text: 'Salvar',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        item.user = userController.text;
                        item.cnpj = maskedController.text;
                        Navigator.of(context).pop();
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
}
