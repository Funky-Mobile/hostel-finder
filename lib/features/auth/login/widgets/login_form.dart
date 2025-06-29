import 'package:flutter/material.dart';
import 'package:hostel_finder/features/auth/widgets/auth_input_field.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';


class LoginForm extends StatefulWidget {

  final GlobalKey<FormState> formKey;

  const LoginForm({super.key, required this.formKey});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {


  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void _disposeTextEditingControllers() {
    _emailController.dispose();
    _passwordController.dispose();
  }


  @override
  void dispose() {
    _disposeTextEditingControllers();
    super.dispose();
  }


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
            controller: _emailController,
            focusNode: _emailFocusNode,
            nextFocusNode: _passwordFocusNode
          ),

          AuthInputField(
            label: CustomAppStrings.passwordString,
            hintText: CustomAppStrings.passwordString.toLowerCase(),
            controller: _passwordController,
            focusNode: _passwordFocusNode
          )
        ],
      ),
    );
  }
}
