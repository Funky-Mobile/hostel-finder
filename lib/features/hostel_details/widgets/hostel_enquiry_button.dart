import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';

import '../../../shared/app_assets/app_assets.dart';
import '../../../shared/custom_app_labels/custom_app_header_text.dart';
import '../../../utils/vertical_item_spacer.dart';
import '../../home/widgets/app_hostel_location.dart';

class HostelEnquiryButton extends StatelessWidget {
  HostelEnquiryButton({super.key});

  final List<String> _reviews = <String>[
    "The walls are paper thin, so if your neighbors are night owls or early birds, you'll know about it. The kitchen gets pretty chaotic during peak hours, and sometimes people don't clean up after themselves, which is frustrating. The laundry facilities are limited, so you have to plan ahead or you'll be waiting forever for a free machine. Also, the hot water can be inconsistent - nothing worse than a cold shower after a long day.",
    "The location is pretty convenient - close to campus and main transport links, so getting to classes isn't a hassle. The common areas are decent for studying or hanging out with friends, and the wifi is surprisingly reliable most of the time. I've met some great people here, and there's always someone around if you want company or need help with something. The rent is reasonable compared to other options in the area, which is crucial on a student budget.",
    "Maintenance requests take forever to get addressed. I've been waiting three weeks for them to fix my desk lamp. The bathrooms could use more frequent deep cleaning, and don't get me started on the state of things during exam period when everyone's stressed and living on instant noodles.",
    "It's not luxury living, but it does the job. You get what you pay for, and honestly, the social aspect makes up for a lot of the inconveniences. Would I recommend it? If you're looking for affordable accommodation and don't mind some quirks, then yeah. Just invest in good earplugs and maybe a mini kettle for your room.",
    "The location is pretty convenient - close to campus and main transport links, so getting to classes isn't a hassle. The common areas are decent for studying or hanging out with friends, and the wifi is surprisingly reliable most of the time. I've met some great people here, and there's always someone around if you want company or need help with something. The rent is reasonable compared to other options in the area, which is crucial on a student budget.",
    "Maintenance requests take forever to get addressed. I've been waiting three weeks for them to fix my desk lamp. The bathrooms could use more frequent deep cleaning, and don't get me started on the state of things during exam period when everyone's stressed and living on instant noodles.",
    "It's not luxury living, but it does the job. You get what you pay for, and honestly, the social aspect makes up for a lot of the inconveniences. Would I recommend it? If you're looking for affordable accommodation and don't mind some quirks, then yeah. Just invest in good earplugs and maybe a mini kettle for your room."
  ];

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
      showDragHandle: true,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAppHeaderText(
                              text: "Glorious Queens Hostel",
                              size: 24,
                              maxLines: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            AppHostelLocation(
                              location: "Adenta Municipality",
                              color: Colors.black,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            // Todo: call the facility
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              CupertinoColors.activeGreen,
                            ),
                          ),
                          icon: const Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    CustomAppHeaderText(
                      text: "Reviews",
                      size: 24,
                      fontWeight: FontWeight.bold,
                    ),

                    const SizedBox(height: 8),
                    ..._reviews.map((review) => _hostelReview(review)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  Widget _hostelReview(String review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(5),
                child: Image.asset(
                  AppAssets.hostel3,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBodyText(
                      text: "Joshua K. Buduug", //Todo: get data from backend
                      fontWeight: FontWeight.bold,
                    ),

                    CustomAppBodyText(
                      text: "12 June, 2025", //Todo: get data from backend
                      textColor: Colors.black54,
                    )
                  ],
                ),
              )
            ],
          ),

          Row(
            children: [
              Flexible(
                  child: CustomAppBodyText(
                    text: review,
                  ) //Todo: get data from backend
              )
            ],
          )
        ],
      ),
    );
  }
}
