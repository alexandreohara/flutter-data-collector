import 'package:data_collector/design/colors.dart';
import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField({
    this.labelText,
    this.hintText,
    this.errorText,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.onChanged,
    this.isValid,
    this.maxLength,
    this.inputFormatters,
  });

  final String labelText;
  final String hintText;
  final String errorText;
  final bool isValid;
  final dynamic controller;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final Function onChanged;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        labelText: labelText ?? '',
        hintText: hintText ?? '',
        errorText: errorText ?? null,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(BORDER_RADIUS_8),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(BORDER_RADIUS_8),
          ),
        ),
      ),
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
    );
  }
}
