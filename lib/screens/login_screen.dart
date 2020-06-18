import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode loginFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InputField(
              onChanged: () {},
              maxLength: 10,
              focusNode: loginFocusNode,
              labelText: 'Nome',
              isValid: false,
            ),
            Center(
              child: PrimaryButton(
                text: 'Login',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
