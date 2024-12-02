import 'dart:io';

import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/camera.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:data_collector/service_account.dart';
import 'package:data_collector/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    var service = Provider.of<AuthService>(context);
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
                  onPressed: () => _takePicture(
                    '${item.number!}',
                  ),
                ),
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
                    showConfirmationDialog(context, item: item,
                        onConfirm: () async {
                      Navigator.of(context).pop();
                      showLoadingDialog(context);
                      try {
                        await _handleConfirmation(service, item, picture);
                        Navigator.of(context).pop();
                        showSuccessDialog(context);
                      } on FetchSheetException catch (e) {
                        Navigator.of(context).pop();
                        showErrorDialog(context, error: e.toString());
                      } on ErrorAddingRowException catch (e) {
                        Navigator.of(context).pop();
                        showErrorDialog(context, error: e.toString());
                      } on NumberAlreadyExistsException catch (e) {
                        Navigator.of(context).pop();
                        showWarningDialog(context, message: '$e');
                      } on Exception catch (e) {
                        Navigator.of(context).pop();
                        showErrorDialog(context, error: e.toString());
                      }
                    }, onCancel: Navigator.of(context).pop);
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

  Future<void> _takePicture(String filename) async {
    pictureName = filename;
    Camera().takePicture(pictureName).then((File? file) {
      if (mounted) {
        setState(() {
          picture = file;
        });
      }
    });
  }
}

Future<void> _handleConfirmation(
    AuthService service, Item item, File? picture) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final cnpjFolder = await prefs.getString('folderId');
    await service.fetchSheets(cnpjFolder!, 'Dados - ${item.cnpj}');
    if (picture != null) {
      await service.uploadFile(cnpjFolder, picture);
    }
    await service.addRowToSpreadsheet(service.sheet!.id!, item);
  } catch (e) {
    print('Error adding row: $e');
    rethrow;
  }
}

void showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        children: [
          Lottie.asset(
            'lib/assets/images/success-animation.json',
            height: 100,
            repeat: false,
          ),
          Center(
            child: Text('Dados salvos com sucesso!',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(
            height: SPACING_16,
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/', (route) => false),
            child: Text('Retornar pra o início'),
          ),
        ],
      );
    },
  );
}

void showErrorDialog(BuildContext context, {required String error}) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        children: [
          Lottie.asset(
            'lib/assets/images/error-animation.json',
            height: 100,
            repeat: false,
          ),
          Center(
            child: Text('Ocorreu um erro: $error',
                style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(
            height: SPACING_16,
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Retornar'),
          ),
        ],
      );
    },
  );
}

void showWarningDialog(BuildContext context, {required String message}) {
  showDialog(
    context: context,
    builder: (context) {
      return SimpleDialog(
        children: [
          Lottie.asset(
            'lib/assets/images/warning-animation.json',
            height: 100,
            repeat: false,
          ),
          Center(
            child: Text(message, style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(
            height: SPACING_16,
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, '/', (route) => false),
            child: Text('Recomeçar'),
          ),
        ],
      );
    },
  );
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return SimpleDialog(
        children: [
          Lottie.asset(
            'lib/assets/images/loading-animation.json',
            height: 200,
            repeat: true,
          ),
          Center(
            child: Text(
              'Salvando no Google Drive...',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          SizedBox(
            height: SPACING_24,
          ),
        ],
      );
    },
  );
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
