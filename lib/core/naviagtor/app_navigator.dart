import 'package:flutter/material.dart';

class AppNavigator {

  static void navigateTo(BuildContext context, Widget page) => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => page));
}
