import 'package:data_collector/screens/form_screen.dart';
import 'package:data_collector/screens/home_screen.dart';
import 'package:data_collector/screens/identification_screen.dart';
import 'package:data_collector/screens/login_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => HomeScreen());
      break;
    case '/login':
      return MaterialPageRoute(builder: (context) => LoginScreen());
      break;
    case '/identification':
      return MaterialPageRoute(builder: (context) => IdentificationScreen());
      break;
    case '/form':
      return MaterialPageRoute(builder: (context) => FormScreen());
      break;
    default:
      return MaterialPageRoute(builder: (context) => Scaffold());
      break;
  }
}
