import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppIcon extends StatelessWidget {

  final IconData icon;
  final Color? color;

  const CustomAppIcon({super.key, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 18,
      color: color ?? Colors.black,
    );
  }
}
