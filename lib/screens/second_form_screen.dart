import 'dart:io';

import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/camera.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecondFormScreen extends StatefulWidget {
  @override
  _SecondFormScreenState createState() => _SecondFormScreenState();
}

class _SecondFormScreenState extends State<SecondFormScreen> {
  final FocusNode locationFocusNode = FocusNode();
  final TextEditingController locationController = TextEditingController();
  final FocusNode observationFocusNode = FocusNode();
  final TextEditingController observationController = TextEditingController();
  double _value = 100;

  File? picture;
  String? pictureName;

  @override
  void dispose() {
    locationController.dispose();
    observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var item = Provider.of<Item>(context);
    print(item.cnpj);
    print(item.supplier);
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
            title: Text('Adicionar informações'),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  item.incidentState = null;
                  item.location = null;
                  item.observations = null;
                  Navigator.of(context).pop();
                })),
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
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return Slider(
                    value: _value,
                    label: "${_value.round()}",
                    divisions: 4,
                    min: 0,
                    max: 100,
                    onChanged: (newValue) {
                      setState(() => _value = newValue);
                    },
                  );
                }),
                SizedBox(
                  height: SPACING_16,
                ),
                InputField(
                  onChanged: (text) {},
                  focusNode: locationFocusNode,
                  controller: locationController,
                  labelText: 'Localização',
                  isValid: true,
                  maxLength: 100,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                InputField(
                  onChanged: (text) {},
                  focusNode: observationFocusNode,
                  controller: observationController,
                  labelText: 'Observações',
                  isValid: true,
                  maxLength: 100,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                Text(
                  'Adicionar foto?',
                  style: theme.textTheme.headlineSmall,
                ),
                SizedBox(
                  height: SPACING_16,
                ),
                SecondaryButton(
                    text: pictureName != null
                        ? 'Substituir foto'
                        : 'Adicionar foto',
                    onPressed: () => _takePicture()),
                SizedBox(
                  height: SPACING_48,
                ),
                _pictureOrPlaceholder(),
                SizedBox(
                  height: SPACING_48,
                ),
                PrimaryButton(
                  text: 'Concluir',
                  onPressed: () {
                    item.incidentState = '${_value.round()}';
                    item.location = locationController.text;
                    item.observations = observationController.text;
                    showConfirmationDialog(context,
                        item: item,
                        onConfirm: () {},
                        onCancel: Navigator.of(context).pop);
                    // Navigator.of(context)
                    //     .popUntil(ModalRoute.withName('/home'));
                  },
                ),
                SizedBox(
                  height: SPACING_48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pictureOrPlaceholder() {
    if (picture != null) {
      var bytes = picture!.readAsBytesSync();
      return Image.memory(bytes, height: 300);
    }
    return Image.asset('lib/assets/images/image-placeholder.png', height: 100);
  }

  Future<void> _takePicture() async {
    pictureName = "teste.jpg";
    Camera().takePicture(pictureName).then((File? file) {
      if (mounted) {
        setState(() {
          picture = file;
        });
      }
    });
  }
}

void showConfirmationDialog(
  BuildContext context, {
  required Item item,
  required VoidCallback onConfirm,
  required VoidCallback onCancel,
}) {
  String displayValue(String? value) {
    return (value == null || value.isEmpty) ? '-' : value;
  }

  Widget buildRichText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodySmall,
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirme os dados:'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRichText('Placa', displayValue(item.number.toString())),
              buildRichText('Fornecedor', displayValue(item.supplier)),
              buildRichText('Modelo', displayValue(item.model)),
              buildRichText('Tipo', displayValue(item.type)),
              buildRichText('Descrição', displayValue(item.description)),
              buildRichText(
                  'Estado do item', '${displayValue(item.incidentState)}%'),
              buildRichText('Localização', displayValue(item.location)),
              buildRichText('Observações', displayValue(item.observations)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: onCancel,
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: onConfirm,
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
