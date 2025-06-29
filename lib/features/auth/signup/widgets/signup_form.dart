import 'package:flutter/cupertino.dart';
import 'package:hostel_finder/features/auth/widgets/auth_input_field.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';

class SignupForm extends StatefulWidget {

  final GlobalKey<FormState> formKey;


  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignupForm({super.key, required this.formKey, required this.fullNameController, required this.emailController, required this.passwordController, required this.confirmPasswordController});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {


  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        children: [

          AuthInputField(
            controller: widget.fullNameController,
            label: CustomAppStrings.fullNameString,
            hintText: CustomAppStrings.fullNameString.toLowerCase(),
            focusNode: _fullNameFocusNode,
            nextFocusNode: _emailFocusNode,
          ),

          AuthInputField(
            controller: widget.emailController,
            label: CustomAppStrings.emailString,
            hintText: CustomAppStrings.emailString.toLowerCase(),
            focusNode: _emailFocusNode,
            nextFocusNode: _passwordFocusNode,
          ),

          AuthInputField(
            controller: widget.passwordController,
            isPassword: true,
            label: CustomAppStrings.passwordString,
            hintText: CustomAppStrings.passwordString.toLowerCase(),
            focusNode: _passwordFocusNode,
            nextFocusNode: _confirmPasswordFocusNode,
          ),

          AuthInputField(
            controller: widget.confirmPasswordController,
            isPassword: true,
            label: CustomAppStrings.confirmPasswordString,
            hintText: CustomAppStrings.confirmPasswordString.toLowerCase(),
            focusNode: _confirmPasswordFocusNode
          )
        ],
      ),
    );
  }
}
