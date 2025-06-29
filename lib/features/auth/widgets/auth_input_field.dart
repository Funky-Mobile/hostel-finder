import 'package:flutter/material.dart';

import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/text_fields/custom_text_form_field.dart';

class AuthInputField extends StatefulWidget {

  final String label;
  final String hintText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextEditingController? controller;
  final bool? isPassword;

  const AuthInputField({super.key, required this.label, required this.hintText, required this.focusNode, this.nextFocusNode, this.controller, this.isPassword});

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBodyText(
              text: "${widget.label}*",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textColor: Colors.white
          ),

          const SizedBox(height: 8.0),

          CustomTextFormField(
            isPassword: widget.isPassword,
            controller: widget.controller,
            focusNode: widget.focusNode,
            nextFocusNode: widget.nextFocusNode,
            hintText: widget.hintText,
          )
        ],
      ),
    );
  }
}
