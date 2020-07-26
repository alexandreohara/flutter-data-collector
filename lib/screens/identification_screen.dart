import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/helpers.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class IdentificationScreen extends StatefulWidget {
  @override
  _IdentificationScreenState createState() => _IdentificationScreenState();
}

class _IdentificationScreenState extends State<IdentificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode cnpjFocusNode = FocusNode();
  final maskedController =
      MaskedTextController(mask: '00.000.000/0000-00', text: '');

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
                    'Antes de começar, digite o seu nome e o CNPJ do cliente',
                    style: theme.textTheme.headline5,
                  ),
                  Text(
                    'Você poderá alterar essas informações futuramente',
                    style: theme.textTheme.bodyText2,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    validator: (value) => requiredValidator(value),
                    maxLength: 10,
                    focusNode: nameFocusNode,
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
                    text: 'Coletar dados',
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pushNamed(context, '/form');
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
