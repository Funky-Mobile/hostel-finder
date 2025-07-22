import 'package:flutter/material.dart';
import 'package:hostel_finder/core/app_routes.dart';
import 'package:hostel_finder/core/custom_scaffold_body.dart';
import 'package:hostel_finder/features/auth/login/widgets/login_form.dart';
import 'package:hostel_finder/features/auth/widgets/auth_button.dart';
import 'package:hostel_finder/features/auth/widgets/auth_navigation_button.dart';
import 'package:hostel_finder/features/auth/widgets/auth_screens_header.dart';
import 'package:hostel_finder/shared/app_assets/app_assets.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/shared/custom_buttons/custom_elevated_icon_button.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';

import 'package:get/get.dart';

import '../controller/auth_controller.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {

      _authController.login(
        context: context,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                AuthScreensHeader(heading: CustomAppStrings.loginHeaderString, body: CustomAppStrings.loginSubHeadingString),

                VerticalItemSpacer(child: LoginForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                )),

                Obx(() => _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : AuthButton(
                  formKey: _formKey,
                  buttonText: CustomAppStrings.loginButtonString,
                  onPressed: _handleLogin,
                )),

                AuthNavigationButton(question: CustomAppStrings.donNotHaveAccountString, routeName: CustomAppStrings.registerString, route: AppRoutes.signUpScreen),

                VerticalItemSpacer(
                  space: MediaQuery.of(context).size.height * .025,
                  child: CustomAppHeaderText(text: CustomAppStrings.orString, fontWeight: FontWeight.bold),
                ),

                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedIconButton(
                        assetIcon: AppAssets.googleIcon,
                        buttonText: CustomAppStrings.continueWithGoogleString,
                        onPressed: () { _authController.loginWithGoogle(context); }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
