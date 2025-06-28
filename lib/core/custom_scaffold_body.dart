import 'package:flutter/material.dart';

class CustomScaffoldBody extends StatelessWidget {

  final Widget body;

  const CustomScaffoldBody({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.white]
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: body,
        ),
      ),
    );
  }
}
