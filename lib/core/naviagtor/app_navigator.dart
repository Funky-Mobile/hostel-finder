import 'package:flutter/material.dart';

class AppNavigator {

  static void navigateTo(BuildContext context, String route) => Navigator.of(context).pushNamed(route);

  static void popAllUntil(BuildContext context, String route) => Navigator.of(context).pushNamedAndRemoveUntil(route, (Route r) => false);

}
