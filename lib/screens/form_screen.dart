import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/helpers.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode oldNumberFocusNode = FocusNode();
  final TextEditingController oldNumberController = TextEditingController();
  final FocusNode newNumberFocusNode = FocusNode();
  final TextEditingController newNumberController = TextEditingController();
  final FocusNode serialNumberFocusNode = FocusNode();
  final TextEditingController serialNumberController = TextEditingController();
  final FocusNode supplierFocusNode = FocusNode();
  final TextEditingController supplierController = TextEditingController();
  final FocusNode modelFocusNode = FocusNode();
  final TextEditingController modelController = TextEditingController();
  final FocusNode typeFocusNode = FocusNode();
  final TextEditingController typeController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    oldNumberController.dispose();
    serialNumberController.dispose();
    newNumberController.dispose();
    supplierFocusNode.dispose();
    modelController.dispose();
    typeController.dispose();
    descriptionController.dispose();
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
                onPressed: () {
                  item.name = null;
                  item.number = null;
                  item.supplier = null;
                  item.model = null;
                  item.type = null;
                  item.description = null;
                  Navigator.of(context).pop();
                })),
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
                    'Preencha os dados abaixo',
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      InputField(
                        focusNode: oldNumberFocusNode,
                        labelText: 'Número da placa antiga',
                        isValid: true,
                        controller: oldNumberController,
                      ),
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/barcode-scanner.png',
                        ),
                        onPressed: () async =>
                            oldNumberController.text = await handleScan(),
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
                        validator: (value) => requiredValidator(value),
                        focusNode: newNumberFocusNode,
                        labelText: 'Nova placa',
                        isValid: true,
                        controller: newNumberController,
                        keyboardType: TextInputType.number,
                      ),
                      IconButton(
                        icon: Image.asset(
                          'lib/assets/icons/barcode-scanner.png',
                        ),
                        onPressed: () async =>
                            newNumberController.text = await handleScan(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    focusNode: supplierFocusNode,
                    controller: supplierController,
                    labelText: 'Fornecedor',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    focusNode: modelFocusNode,
                    controller: modelController,
                    labelText: 'Modelo',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    focusNode: typeFocusNode,
                    controller: typeController,
                    labelText: 'Tipo',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_16,
                  ),
                  InputField(
                    focusNode: descriptionFocusNode,
                    controller: descriptionController,
                    labelText: 'Descrição',
                    isValid: true,
                  ),
                  SizedBox(
                    height: SPACING_48,
                  ),
                  PrimaryButton(
                    text: 'Continuar',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        item.name = oldNumberController.text;
                        item.number = int.parse(newNumberController.text);
                        item.supplier = supplierController.text;
                        item.model = modelController.text;
                        item.type = typeController.text;
                        item.description = descriptionController.text;

                        Navigator.pushNamed(context, '/second-form');
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

  Future<String> handleScan() async {
    var result = await BarcodeScanner.scan();
    return result.rawContent;
  }
}
