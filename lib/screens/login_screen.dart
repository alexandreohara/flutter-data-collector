import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SPACING_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InputField(
                onChanged: () {},
                maxLength: 10,
                focusNode: loginFocusNode,
                labelText: 'Usuário',
                isValid: false,
              ),
              SizedBox(
                height: 16,
              ),
              InputField(
                onChanged: () {},
                maxLength: 10,
                focusNode: loginFocusNode,
                labelText: 'Senha',
                isValid: false,
              ),
              SizedBox(
                height: 16,
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
      ),
    );
  }
}
