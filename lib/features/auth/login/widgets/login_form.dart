import 'package:flutter/material.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:hostel_finder/shared/text_fields/custom_text_form_field.dart';

class LoginForm extends StatefulWidget {

  final GlobalKey<FormState> formKey;

  const LoginForm({super.key, required this.formKey});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {


  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [
          _inputField("Full Name", "full name", _emailFocusNode, _passwordFocusNode),

          _inputField("Password", "password", _passwordFocusNode, null)
        ],
      ),
    );
  }

  Padding _inputField(String label, String hintText, FocusNode focusNode, FocusNode? nextFocusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBodyText(
              text: "$label*",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textColor: Colors.white
          ),

          const SizedBox(height: 8.0),

          CustomTextFormField(
            focusNode: focusNode,
            nextFocusNode: nextFocusNode,
            hintText: hintText,
          )
        ],
      ),
    );
  }
}
