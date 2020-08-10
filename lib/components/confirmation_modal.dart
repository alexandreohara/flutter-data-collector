import 'package:data_collector/components/button.dart';
import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmationModal extends StatelessWidget {
  const ConfirmationModal({
    @required this.onSubmit,
    @required this.onCancel,
  });
  final Function onSubmit;
  final Function onCancel;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      backgroundColor: COLOR_WHITE,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BORDER_RADIUS_8),
      ),
      child: Consumer<Item>(
          builder: (BuildContext context, Item item, Widget child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: SPACING_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: SPACING_24,
              ),
              Text(
                'Confirme os dados:',
                style: theme.textTheme.headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: SPACING_16,
              ),
              Text(
                'Placa antiga: ${item.name}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Placa nova: ${item.number}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Número de Série: ${item.serialNumber}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Fornecedor: ${item.supplier}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Modelo: ${item.model}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Tipo: ${item.type}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Descrição: ${item.description}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Estado do item: ${item.incidentState}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Localização: ${item.location}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Observações: ${item.observations}',
                style: theme.textTheme.caption,
              ),
              Text(
                'Usuário: ${item.user}',
                style: theme.textTheme.caption,
              ),
              Text(
                'CNPJ: ${item.cnpj}',
                style: theme.textTheme.caption,
              ),
              SizedBox(
                height: SPACING_8,
              ),
              PrimaryButton(
                text: 'Confirmar',
                onPressed: onSubmit,
              ),
              SizedBox(
                height: SPACING_16,
              ),
              SecondaryButton(
                text: 'Cancelar',
                onPressed: onCancel,
              ),
              SizedBox(
                height: SPACING_24,
              ),
            ],
          ),
        );
      }),
    );
  }
}
