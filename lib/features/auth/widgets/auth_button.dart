
import 'package:flutter/cupertino.dart';

import '../../../shared/custom_buttons/custom_elevated_button.dart';

class AuthButton extends StatefulWidget {

  final GlobalKey<FormState> formKey;
  final String buttonText;
  final VoidCallback onPressed;

  const AuthButton({super.key, required this.formKey, required this.buttonText, required this.onPressed});

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            onPressed: () {

              if(widget.formKey.currentState!.validate()) {
                widget.onPressed();
              }

            },
            buttonText: widget.buttonText
          ),
        ),
      ],
    );
  }
}
