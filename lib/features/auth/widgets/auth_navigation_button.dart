import 'package:flutter/cupertino.dart';

import '../../../core/naviagtor/app_navigator.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';
import '../../../shared/custom_buttons/custom_text_button.dart';

class AuthNavigationButton extends StatelessWidget {

  final String question;
  final String routeName;
  final String route;

  const AuthNavigationButton({super.key, required this.question, required this.routeName, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAppBodyText(text: question),
          CustomTextButton(
              onPressed: () => AppNavigator.navigateTo(context, route),
              buttonText: routeName
          )
        ],
      ),
    );
  }
}
