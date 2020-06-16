import 'package:data_collector/components/button.dart';
import 'package:data_collector/design/colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      resizeToAvoidBottomPadding: true,
      body: Container(
        child: Center(
          child: PrimaryButton(
            text: 'Login',
            onPressed: () => null,
          ),
        ),
      ),
    );
  }
}
