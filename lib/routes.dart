import 'package:data_collector/screens/home_screen.dart';
import 'package:data_collector/screens/identification_screen.dart';
import 'package:data_collector/screens/login_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => IdentificationScreen());
      break;
    case '/login':
      return MaterialPageRoute(builder: (context) => LoginScreen());
      break;
    default:
      return MaterialPageRoute(builder: (context) => Scaffold());
      break;
  }
}
