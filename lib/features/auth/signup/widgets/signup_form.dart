import 'package:flutter/cupertino.dart';
import 'package:hostel_finder/features/auth/widgets/auth_input_field.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController studentIdController;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController dobController;
  final TextEditingController genderController;
  final TextEditingController facultyController;
  final TextEditingController guardianController;
  final TextEditingController addressController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignupForm({
    super.key,
    required this.formKey,
    required this.studentIdController,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.dobController,
    required this.genderController,
    required this.facultyController,
    required this.guardianController,
    required this.addressController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final FocusNode _studentIdFocusNode = FocusNode();
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();
  final FocusNode _genderFocusNode = FocusNode();
  final FocusNode _facultyFocusNode = FocusNode();
  final FocusNode _guardianFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
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
            controller: widget.studentIdController,
            label: CustomAppStrings.studentIdString,
            hintText: CustomAppStrings.studentIdString.toLowerCase(),
            focusNode: _studentIdFocusNode,
            nextFocusNode: _fullNameFocusNode,
          ),
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
            nextFocusNode: _phoneFocusNode,
          ),
          AuthInputField(
            controller: widget.phoneController,
            label: CustomAppStrings.phoneString,
            hintText: CustomAppStrings.phoneString.toLowerCase(),
            focusNode: _phoneFocusNode,
            nextFocusNode: _dobFocusNode,
          ),
          AuthInputField(
            controller: widget.dobController,
            label: CustomAppStrings.dobString,
            hintText: CustomAppStrings.dobString.toLowerCase(),
            focusNode: _dobFocusNode,
            nextFocusNode: _genderFocusNode,
          ),
          AuthInputField(
            controller: widget.genderController,
            label: CustomAppStrings.genderString,
            hintText: CustomAppStrings.genderString.toLowerCase(),
            focusNode: _genderFocusNode,
            nextFocusNode: _facultyFocusNode,
          ),
          AuthInputField(
            controller: widget.facultyController,
            label: CustomAppStrings.facultyString,
            hintText: CustomAppStrings.facultyString.toLowerCase(),
            focusNode: _facultyFocusNode,
            nextFocusNode: _guardianFocusNode,
          ),
          AuthInputField(
            controller: widget.guardianController,
            label: CustomAppStrings.guardianContactString,
            hintText: CustomAppStrings.guardianContactString.toLowerCase(),
            focusNode: _guardianFocusNode,
            nextFocusNode: _addressFocusNode,
          ),
          AuthInputField(
            controller: widget.addressController,
            label: CustomAppStrings.addressString,
            hintText: CustomAppStrings.addressString.toLowerCase(),
            focusNode: _addressFocusNode,
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
            focusNode: _confirmPasswordFocusNode,
          ),
        ],
      ),
    );
  }
}
