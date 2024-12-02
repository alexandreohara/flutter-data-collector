import 'package:data_collector/components/button.dart';
import 'package:data_collector/components/input_field.dart';
import 'package:data_collector/design/constants.dart';
import 'package:data_collector/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();

  var errorText;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SPACING_16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: SPACING_48),
                child: Image.asset(
                  'lib/assets/images/axxia-logo.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: SPACING_32,
              ),
              InputField(
                keyboardType: TextInputType.visiblePassword,
                errorText: errorText,
                maxLength: 10,
                focusNode: passwordFocusNode,
                labelText: 'Senha',
                isValid: true,
                controller: passwordController,
                obscureText: true,
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: PrimaryButton(
                  text: 'Login',
                  onPressed: () {
                    if (passwordController.text == '1234') {
                      errorText = null;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          settings: RouteSettings(name: '/'),
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    } else {
                      setState(() {
                        errorText = 'Senha incorreta';
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
