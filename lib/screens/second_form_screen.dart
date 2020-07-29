import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class SecondFormScreen extends StatefulWidget {
  @override
  _SecondFormScreenState createState() => _SecondFormScreenState();
}

class _SecondFormScreenState extends State<SecondFormScreen> {
  final FocusNode nameFocusNode = FocusNode();

  final FocusNode cnpjFocusNode = FocusNode();

  final FocusNode serialNumberFocusNode = FocusNode();

  final FocusNode supplierFocusNode = FocusNode();

  final FocusNode modelFocusNode = FocusNode();

  final FocusNode typeFocusNode = FocusNode();

  final FocusNode descriptionFocusNode = FocusNode();
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Adicionar informações'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          )
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: SPACING_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: SPACING_32,
                ),
                Text(
                  'Qual o estado do item?',
                  style: theme.textTheme.headline5,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                Slider(
                  value: _value,
                  label: "${_value.round()}",
                  divisions: 4,
                  min: 0,
                  max: 100,
                  onChanged: (newValue) {
                    setState(() => _value = newValue);
                  },
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                InputField(
                  onChanged: (text) {},
                  focusNode: cnpjFocusNode,
                  labelText: 'Localização',
                  isValid: true,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                InputField(
                  onChanged: (text) {},
                  focusNode: modelFocusNode,
                  labelText: 'Observações',
                  isValid: true,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                Text(
                  'Adicionar foto?',
                  style: theme.textTheme.headline5,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                SecondaryButton(
                  text: 'Adicionar foto',
                  onPressed: () {}),
                SizedBox(
                  height: SPACING_48,
                ),
                PrimaryButton(
                  text: 'Concluir',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
