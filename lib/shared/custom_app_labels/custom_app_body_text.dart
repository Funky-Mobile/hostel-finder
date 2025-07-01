import 'package:flutter/material.dart';

class CustomAppBodyText extends StatelessWidget {

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? fontSize;

  const CustomAppBodyText({super.key, required this.text, this.textColor, this.fontWeight, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Nunito",
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: fontSize ?? 14
      ),
    );
  }
}
