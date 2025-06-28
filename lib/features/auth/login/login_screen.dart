import 'package:flutter/material.dart';
import 'package:hostel_finder/core/custom_scaffold_body.dart';
import 'package:hostel_finder/features/auth/login/widgets/login_form.dart';
import 'package:hostel_finder/features/auth/login/widgets/login_header.dart';
import 'package:hostel_finder/shared/app_assets/app_assets.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/shared/custom_buttons/custom_elevated_button.dart';
import 'package:hostel_finder/shared/custom_buttons/custom_elevated_icon_button.dart';
import 'package:hostel_finder/shared/custom_buttons/custom_text_button.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';


class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffoldBody(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                LoginHeader(),

                VerticalItemSpacer(child: LoginForm(formKey: _formKey)),

                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.validate();
                        },
                        buttonText: CustomAppStrings.loginButtonText,
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomAppBodyText(text: CustomAppStrings.donNotHaveAccountText),
                      CustomTextButton(
                        onPressed: () {},
                        buttonText: CustomAppStrings.registerText
                      )
                    ],
                  ),
                ),

                VerticalItemSpacer(
                  space: MediaQuery.of(context).size.height * .025,
                  child: CustomAppHeaderText(text: CustomAppStrings.orText, fontWeight: FontWeight.bold),
                ),

                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedIconButton(
                        assetIcon: AppAssets.googleIcon,
                        buttonText: CustomAppStrings.continueWithGoogleText,
                        onPressed: () {  }
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
