import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_icons/custom_app_icon.dart';
import '../app_strings/custom_app_strings.dart';

class CustomAppSearchBar extends StatefulWidget {
  const CustomAppSearchBar({super.key});

  @override
  State<CustomAppSearchBar> createState() => _CustomAppSearchBarState();
}

class _CustomAppSearchBarState extends State<CustomAppSearchBar> {

  final TextEditingController _hostelSearchController = TextEditingController();

  @override
  void dispose() {
    _hostelSearchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            controller: _hostelSearchController,
            keyboardType: TextInputType.text,
            leading: CustomAppIcon(icon: CupertinoIcons.search),
            hintText: CustomAppStrings.searchHostelString,
            hintStyle: WidgetStatePropertyAll(
                TextStyle(
                    color: Colors.black45
                )
            ),
            textStyle: WidgetStatePropertyAll(
                TextStyle(
                    color: Colors.black
                )
            ),
            elevation: WidgetStatePropertyAll(3),
            shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                )
            ),
          ),
        ),
      ],
    );
  }
}
