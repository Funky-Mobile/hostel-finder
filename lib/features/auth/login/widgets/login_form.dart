import 'package:flutter/material.dart';
import 'package:hostel_finder/features/auth/widgets/auth_input_field.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';


class LoginForm extends StatefulWidget {

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginForm({super.key, required this.formKey, required this.emailController, required this.passwordController});

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
          AuthInputField(
            label: CustomAppStrings.emailString,
            hintText: CustomAppStrings.emailString.toLowerCase(),
            controller: widget.emailController,
            focusNode: _emailFocusNode,
            nextFocusNode: _passwordFocusNode,
          ),
          AuthInputField(
            label: CustomAppStrings.passwordString,
            hintText: CustomAppStrings.passwordString.toLowerCase(),
            controller: widget.passwordController,
            focusNode: _passwordFocusNode,
          ),
        ],
      ),
    );
  }
}
