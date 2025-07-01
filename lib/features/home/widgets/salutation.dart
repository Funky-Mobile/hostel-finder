import 'package:flutter/material.dart';
import 'package:hostel_finder/features/home/widgets/app_hostel_location.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/utils/app_device.dart';
import '../../../shared/custom_app_labels/custom_app_body_text.dart';

class Salutation extends StatefulWidget {
  const Salutation({super.key});

  @override
  State<Salutation> createState() => _SalutationState();
}

class _SalutationState extends State<Salutation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //Todo: replace name (Joshua) with registered user's name
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: AppDevice.isSmallScreen(context)
            ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomAppBodyText(
                  text: "${CustomAppStrings.hiString} Josh Joshua ${CustomAppStrings.handWaveString}",
                  fontSize: 18,
                  textColor: Colors.white
              ),

              AppHostelLocation(location: "Adenta Municipality", color: Colors.white54)
            ],
          )
            : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAppBodyText(
                    text: "${CustomAppStrings.hiString} Josh Joshua ${CustomAppStrings.handWaveString}", //Todo: this comes from the api response
                    fontSize: 18,
                    textColor: Colors.white
                ),

                AppHostelLocation(location: "Adenta Municipality", color: Colors.white54) //Todo: this comes from the api response
              ],
            ),
        ),

        CustomAppHeaderText(text: CustomAppStrings.homeHeaderString, size: 24, textColor: Colors.white)
      ],
    );
  }
}
