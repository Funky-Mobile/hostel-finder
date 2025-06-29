import 'package:flutter/material.dart';
import 'package:hostel_finder/core/custom_scaffold_body.dart';
import 'package:hostel_finder/features/auth/login/login_screen.dart';
import 'package:hostel_finder/features/auth/signup/widgets/signup_form.dart';
import 'package:hostel_finder/features/auth/widgets/auth_button.dart';
import 'package:hostel_finder/features/auth/widgets/auth_screens_header.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';

import '../widgets/auth_navigation_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey = GlobalKey<FormState>();


  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();


  void _disposeTextEditingControllers() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }



  @override
  void dispose() {
    _disposeTextEditingControllers();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffoldBody(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [

                AuthScreensHeader(heading: CustomAppStrings.signUpHeaderString, body: CustomAppStrings.signUpSubHeadingString),

                VerticalItemSpacer(
                  child: SignupForm(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController
                  ),
                ),

                AuthButton(formKey: _formKey, buttonText: CustomAppStrings.signupButtonString, onPressed: () {
                  if(_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Oops! Your passwords do not match!")
                        )
                    );
                  } else {
                    //Todo: sign up user
                  }
                }),

                AuthNavigationButton(question: CustomAppStrings.alreadyHaveAccountString, routeName: CustomAppStrings.loginString, route: LoginScreen()),

              ],
            ),
          ),
        )
      )
    );
  }
}
