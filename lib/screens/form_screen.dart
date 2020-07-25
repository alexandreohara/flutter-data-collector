import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/helpers.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode cnpjFocusNode = FocusNode();
  final FocusNode serialNumberFocusNode = FocusNode();
  final FocusNode supplierFocusNode = FocusNode();
  final FocusNode modelFocusNode = FocusNode();
  final FocusNode typeFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

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
                    'Preencha os dados abaixo',
                    style: theme.textTheme.headline5,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    onChanged: (text) {},
                    focusNode: nameFocusNode,
                    labelText: 'Número da placa antiga',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    validator: (value) => requiredValidator(value),
                    onChanged: (text) {},
                    focusNode: cnpjFocusNode,
                    labelText: 'Nova placa',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    onChanged: (text) {},
                    focusNode: modelFocusNode,
                    labelText: 'Modelo',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    onChanged: (text) {},
                    focusNode: typeFocusNode,
                    labelText: 'Tipo',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    onChanged: (text) {},
                    focusNode: descriptionFocusNode,
                    labelText: 'Descrição',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_48,
                  ),
                  PrimaryButton(
                    text: 'Continuar',
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
