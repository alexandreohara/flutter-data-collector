import 'package:data_collector/screens/db_test_screen.dart';
import 'package:data_collector/screens/edit_identification_screen.dart';
import 'package:data_collector/screens/form_screen.dart';
import 'package:data_collector/screens/home_screen.dart';
import 'package:data_collector/screens/identification_screen.dart';
import 'package:data_collector/screens/login_screen.dart';
import 'package:data_collector/screens/second_form_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> routes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => LoginScreen());
      break;
    case '/home':
      return MaterialPageRoute(builder: (context) => HomeScreen());
      break;
    case '/identification':
      return MaterialPageRoute(builder: (context) => IdentificationScreen());
      break;
    case '/edit-identification':
      return MaterialPageRoute(
          builder: (context) => EditIdentificationScreen());
      break;
    case '/form':
      return MaterialPageRoute(builder: (context) => FormScreen());
      break;
    case '/second-form':
      return MaterialPageRoute(builder: (context) => SecondFormScreen());
      break;
    case '/test-db':
      return MaterialPageRoute(builder: (context) => TestDatabase());
      break;
    default:
      return MaterialPageRoute(builder: (context) => Scaffold());
      break;
  }
}
