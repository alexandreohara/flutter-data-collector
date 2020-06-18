import 'package:data_collector/design/colors.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.text,
    this.textColor,
    @required this.onPressed,
  });

  final String text;
  final Color textColor;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(color: textColor ?? COLOR_WHITE),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
