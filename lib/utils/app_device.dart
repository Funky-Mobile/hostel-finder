import 'package:flutter/cupertino.dart';

class AppDevice {

  static bool isSmallScreen(BuildContext context) => MediaQuery.of(context).size.width > 380;

}