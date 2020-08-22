import 'package:barcode_scan/barcode_scan.dart';
import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/helpers.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FocusNode barCodeFocusNode = FocusNode();
  final TextEditingController barCodeController = TextEditingController();
  final FocusNode serialNumberFocusNode = FocusNode();
  final TextEditingController serialNumberController = TextEditingController();

  var errorText;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pesquisar'),
        ),
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: SPACING_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: SPACING_32,
                  ),
                  Text(
                    'Pesquise o item para preenchimento automático',
                    style: theme.textTheme.headline5,
                  ),
                  Text(
                    'Digite ou utilize a câmera para escanear',
                    style: theme.textTheme.bodyText1,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      InputField(
                        focusNode: barCodeFocusNode,
                        labelText: 'Código de barras',
                        isValid: true,
                        controller: barCodeController,
                        validator: (value) => requiredValidator(value),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/barcode-scanner.png',
                        ),
                        onPressed: () async =>
                            barCodeController.text = await handleScan(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      InputField(
                        focusNode: serialNumberFocusNode,
                        labelText: 'Número de série',
                        isValid: true,
                        controller: serialNumberController,
                        validator: (value) => requiredValidator(value),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/barcode-scanner.png',
                        ),
                        onPressed: () async =>
                            serialNumberController.text = await handleScan(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SPACING_48,
                  ),
                  PrimaryButton(
                    text: 'Pesquisar',
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pushNamed(context, '/form');
                      }
                    },
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  SecondaryButton(
                    text: 'Inserir dados manualmente',
                    onPressed: () {
                      Navigator.pushNamed(context, '/form');
                    },
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> handleScan() async {
    var result = await BarcodeScanner.scan();
    return result?.rawContent ?? '';
  }
}
