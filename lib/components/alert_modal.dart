import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class AlertModal extends StatelessWidget {
  const AlertModal({
    this.title,
    this.content,
    @required this.onSubmit,
    @required this.onCancel,
  });

  final Widget title;
  final String content;
  final Function onSubmit;
  final Function onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: title,
      titleTextStyle: theme.textTheme.headline6,
      actions: <Widget>[
        FlatButton(
          child: Text('Sim'),
          onPressed: onSubmit,
        ),
        FlatButton(
          child: Text('Cancelar'),
          textColor: COLOR_GRAY_4,
          onPressed: onCancel,
        )
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: SPACING_8),
      content: Text(content ?? ''),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BORDER_RADIUS_8),
      ),
    );
  }
}
