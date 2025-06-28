import 'package:flutter/material.dart';

class CustomAppHeaderText extends StatelessWidget {

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;

  const CustomAppHeaderText({super.key, required this.text, this.textColor, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 32,
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal
      ),
    );
  }
}
