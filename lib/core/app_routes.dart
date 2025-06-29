import 'package:flutter/cupertino.dart';
import 'package:hostel_finder/features/auth/login/login_screen.dart';
import 'package:hostel_finder/features/auth/signup/signup_screen.dart';
import 'package:hostel_finder/features/home/home_screen.dart';

class AppRoutes {

  static String get loginScreen => 'loginScreen';
  static String get signUpScreen => 'signUpScreen';
  static String get homeScreen => 'homeScreen';


  static Map<String, WidgetBuilder> get routes => {
    'loginScreen': (context) => LoginScreen(),
    'signUpScreen': (context) => SignupScreen(),
    'homeScreen': (context) => HomeScreen()
  };
}