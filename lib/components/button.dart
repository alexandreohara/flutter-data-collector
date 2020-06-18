import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
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
    final theme = Theme.of(context);

    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BORDER_RADIUS_32),
      ),
      color: theme.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(SPACING_16),
        child: Text(
          text,
          style:
              theme.textTheme.button.copyWith(color: textColor ?? COLOR_WHITE),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
