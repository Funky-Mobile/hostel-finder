import 'package:flutter/cupertino.dart';

class VerticalItemSpacer extends StatelessWidget {

  final Widget child;
  final double? space;

  const VerticalItemSpacer({super.key, required this.child, this.space});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: space ?? MediaQuery.of(context).size.height * .05),
      child: child,
    );
  }
}
