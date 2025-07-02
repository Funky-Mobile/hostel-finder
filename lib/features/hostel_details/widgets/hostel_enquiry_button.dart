import 'package:flutter/material.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';

import '../../../utils/vertical_item_spacer.dart';

class HostelEnquiryButton extends StatelessWidget {
  const HostelEnquiryButton({super.key});


  @override
  Widget build(BuildContext context) {


    return VerticalItemSpacer(
      space: MediaQuery.of(context).size.height * .015,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showBottomModalSheet(context),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.grey)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomAppBodyText(
                  text: CustomAppStrings.makeEnquiriesString,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(

            width: double.infinity,

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                )
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [

                  CustomAppBodyText(
                    text: CustomAppStrings.availableChannelsString,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),

                ],
              ),
            ),
          );
        }
    );
  }
}
