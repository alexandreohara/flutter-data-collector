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
    case '/home':
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case '/identification':
      return MaterialPageRoute(builder: (context) => IdentificationScreen());
    case '/edit-identification':
      return MaterialPageRoute(
          builder: (context) => EditIdentificationScreen());
    case '/form':
      return MaterialPageRoute(builder: (context) => FormScreen());
    case '/second-form':
      return MaterialPageRoute(builder: (context) => SecondFormScreen());
    case '/test-db':
      return MaterialPageRoute(builder: (context) => TestDatabase());
    default:
      return MaterialPageRoute(builder: (context) => Scaffold());
  }
}
