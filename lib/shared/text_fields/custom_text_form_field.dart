import 'package:flutter/material.dart';

import '../custom_app_labels/custom_app_body_text.dart';

class CustomTextFormField extends StatefulWidget {

  final String? hintText;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;

  const CustomTextFormField({super.key, required this.focusNode, this.nextFocusNode, this.hintText});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'This is a required field';
          }
          return null;
        },
        focusNode: widget.focusNode,
        onEditingComplete: widget.nextFocusNode != null ? ()=> FocusScope.of(context).requestFocus(widget.nextFocusNode) : ()=> FocusScope.of(context).unfocus(),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hint: CustomAppBodyText(
              text: widget.hintText ?? "hint text",
              textColor: Colors.white54,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.white54
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: Colors.white54
                )
            )
        )
    );
  }
}
