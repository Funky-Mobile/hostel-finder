import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/custom_app_labels/custom_app_body_text.dart';

class HostelAmenity extends StatelessWidget {

  final String amenity;
  const HostelAmenity({required this.amenity, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black54, Colors.white],
              begin: FractionalOffset.topRight,
              end: Alignment.bottomRight
          ),
          borderRadius: BorderRadiusGeometry.circular(50)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomAppBodyText(
            text: amenity,
            fontSize: 12,
            textColor: Colors.white
        ),
      ),
    );
  }
}
