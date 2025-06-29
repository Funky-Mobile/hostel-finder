import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../custom_app_labels/custom_app_body_text.dart';

class CustomTextFormField extends StatefulWidget {

  final String? hintText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController? controller;
  final bool? isPassword;

  const CustomTextFormField({super.key, required this.focusNode, this.nextFocusNode, this.hintText, this.controller, this.isPassword});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

  bool showPassword = true;

  @override
  Widget build(BuildContext context) {

    bool isPassword = widget.isPassword ?? false;

    return TextFormField(
        validator: (value) {
          if(value == null || value.isEmpty) {
            return 'This is a required field';
          }

          if(value.isNotEmpty && isPassword && value.length < 8) {
            return 'Password length is too short';
          }

          return null;
        },
        controller: widget.controller,
        focusNode: widget.focusNode,
        onEditingComplete: widget.nextFocusNode != null ? ()=> FocusScope.of(context).requestFocus(widget.nextFocusNode) : ()=> FocusScope.of(context).unfocus(),
        style: TextStyle(color: Colors.white),
        obscureText: isPassword ? showPassword : false,
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
          ),
          suffix: isPassword
              ? InkWell(
                  onTap: () => setState(() {
                    showPassword = !showPassword;
                  }),
                  child: Icon(
                    showPassword ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                    color: Colors.white60,
                    size: 20,
                  ))
              : null
        )
    );
  }
}
