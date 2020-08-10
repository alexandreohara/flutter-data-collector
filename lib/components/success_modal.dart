import 'package:data_collector/components/button.dart';
import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/models/Item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

class SuccessModal extends StatelessWidget {
  const SuccessModal({
    @required this.onSubmit,
  });
  final Function onSubmit;

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
              Container(
                width: 240,
                height: 240,
                child: FlareActor(
                  'lib/assets/images/success-check.flr',
                  animation: 'Untitled',
                ),
              ),
              Text(
                'Item registrado com sucesso!',
                style: theme.textTheme.headline5
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
