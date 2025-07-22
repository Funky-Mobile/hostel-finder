import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/features/auth/signup/widgets/signup_form.dart';
import 'package:hostel_finder/features/auth/widgets/auth_button.dart';
import 'package:hostel_finder/features/auth/widgets/auth_navigation_button.dart';
import 'package:hostel_finder/features/auth/widgets/auth_screens_header.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/core/custom_scaffold_body.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';

import '../controller/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Oops! Your passwords do not match!")),
        );
        return;
      }

      _authController.signup(
        context: context,
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffoldBody(
        useGlassmorphism: true,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AuthScreensHeader(
                  heading: CustomAppStrings.signUpHeaderString,
                  body: CustomAppStrings.signUpSubHeadingString,
                ),
                VerticalItemSpacer(
                  child: SignupForm(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                  ),
                ),

                Obx(() => _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : AuthButton(
                          formKey: _formKey,
                          buttonText: CustomAppStrings.signupButtonString,
                          onPressed: _handleSignup,
                    )
                ),
                AuthNavigationButton(
                  question: CustomAppStrings.alreadyHaveAccountString,
                  routeName: CustomAppStrings.loginString,
                  route: '/login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
