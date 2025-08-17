import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_body_text.dart';
import 'package:hostel_finder/shared/app_assets/app_assets.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../home/widgets/app_hostel_location.dart';

class HostelEnquiryButton extends StatelessWidget {
  final String name;
  final String location;
  final List<ReviewModel> reviews;
  final String? phoneNumber;

  const HostelEnquiryButton({
    super.key,
    required this.name,
    required this.location,
    required this.reviews,
    required this.phoneNumber
  });

  @override
  Widget build(BuildContext context) {
    return VerticalItemSpacer(
      space: MediaQuery.of(context).size.height * .015,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _showBottomModalSheet(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.all(16.0),
              ),
              child: CustomAppBodyText(
                text: CustomAppStrings.makeEnquiriesString,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                textColor: Colors.white,
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              controller: controller,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top header with name + location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAppHeaderText(
                              text: name,
                              size: 24,
                              maxLines: 2,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 4),
                            AppHostelLocation(
                              location: location,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (phoneNumber != null) {
                            _launchPhoneCall(context, phoneNumber!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Phone number not available.")),
                            );
                          }
                        },

                        style: IconButton.styleFrom(
                          backgroundColor: CupertinoColors.activeGreen,
                        ),
                        icon: const Icon(Icons.call, color: Colors.white),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  CustomAppHeaderText(
                    text: "Reviews",
                    size: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),

                  // All Reviews
                  ...reviews.map(_hostelReview),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _hostelReview(ReviewModel review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  review.profilePhotoUrl ?? AppAssets.hostel3,
                  height: 42,
                  width: 42,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Image.asset(AppAssets.appIcon, height: 42, width: 42),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBodyText(
                      text: review.reviewerName,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomAppBodyText(
                      text: review.reviewDate,
                      textColor: Colors.black54,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(
                          index < review.rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: Colors.orange,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          // Review Text
          CustomAppBodyText(text: review.reviewText),
        ],
      ),
    );
  }


  void _launchPhoneCall(BuildContext context, String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not launch dialer.")),
        );
      }
    }
  }

}
