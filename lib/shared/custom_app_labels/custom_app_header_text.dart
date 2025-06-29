import 'package:flutter/material.dart';

class CustomAppHeaderText extends StatelessWidget {

  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? size;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomAppHeaderText({super.key, required this.text, this.textColor, this.fontWeight, this.size, this.maxLines, this.overflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size ?? 32,
        color: textColor ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.normal,
        overflow: overflow ?? TextOverflow.ellipsis
      ),
      maxLines: maxLines ?? 1000,
    );
  }
}
