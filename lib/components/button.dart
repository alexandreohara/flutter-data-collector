import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    this.text = "",
    this.textColor,
    required this.onPressed,
  });

  final String text;
  final Color? textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BORDER_RADIUS_32),
        ),
        backgroundColor: theme.primaryColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(SPACING_8),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium!
              .copyWith(color: textColor ?? COLOR_WHITE),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.text,
    this.color,
    required this.onPressed,
  });

  final String text;
  final Color? color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color ?? theme.primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(BORDER_RADIUS_32),
        ),
        backgroundColor: COLOR_WHITE,
      ),
      child: Padding(
        padding: EdgeInsets.all(SPACING_16),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium!
              .copyWith(color: color ?? theme.primaryColor),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
