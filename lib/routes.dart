import 'package:data_collector/screens/home_screen.dart';
import 'package:data_collector/screens/login_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => HomeScreen());
      break;
    case '/home':
      return MaterialPageRoute(builder: (context) => Scaffold());
      break;
    default:
      return MaterialPageRoute(builder: (context) => Scaffold());
      break;
  }
}
