import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hostel_finder/core/data/hostel_model.dart';
import 'package:hostel_finder/features/all_hostels/all_hostels.dart';
import 'package:hostel_finder/features/home/widgets/nearby_hostels.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostel_card.dart';
import 'package:hostel_finder/features/home/widgets/view_all_hostels_button.dart';
import 'package:hostel_finder/features/hostel_details/hostel_detail.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/custom_app_labels/custom_app_header_text.dart';
import 'package:google_place/google_place.dart';

class PopularHostels extends StatelessWidget {
  final List<SearchResult> hostels;
  final GooglePlace _googlePlace = GooglePlace(dotenv.env['GOOGLE_API_KEY']!);

  PopularHostels({super.key, required this.hostels});

  List<String> generateAmenities(List<String> types) {
    final amenities = <String>{};

    for (final type in types) {
      switch (type) {
        case "lodging":
          amenities.add("24/7 Service");
          amenities.add("Security");
          break;
        case "restaurant":
        case "food":
          amenities.add("Kitchen");
          break;
        case "laundry":
          amenities.add("Laundry");
          break;
        case "library":
          amenities.add("Study Area");
          break;
        case "internet_cafe":
        case "wifi":
          amenities.add("WiFi");
          break;
        case "parking":
          amenities.add("Parking");
          break;
        case "gym":
          amenities.add("Gym");
          break;
        case "spa":
          amenities.add("Relaxation Room");
          break;
        case "convenience_store":
          amenities.add("Mini Shop");
          break;
        case "bank":
          amenities.add("ATM Access");
          break;
      }
    }

    return amenities.isEmpty ? ["Basic Amenities"] : amenities.toList();
  }

  @override
  Widget build(BuildContext context) {
    final popular = hostels.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ---- Horizontal List for Top Hostels ----
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: popular.map((place) {
              final photoRef = place.photos?.firstOrNull?.photoReference;
              final imageUrl = photoRef != null
                  ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=${dotenv.env['GOOGLE_API_KEY']}"
                  : "assets/icons/app/app-icon.png";

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () async {
                    final placeId = place.placeId;
                    if (placeId == null) return;

                    final details = await _googlePlace.details.get(placeId);
                    final placeDetails = details?.result;

                    final photos = (placeDetails?.photos ?? []).map((photo) {
                      return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${photo.photoReference}&key=${dotenv.env['GOOGLE_API_KEY']}";
                    }).toList();

                    final reviews = (placeDetails?.reviews ?? []).map((r) {
                      return ReviewModel(
                        reviewerName: r.authorName ?? "Anonymous",
                        reviewDate: r.relativeTimeDescription ?? "Unknown Date",
                        reviewText: r.text ?? "",
                        profilePhotoUrl: r.profilePhotoUrl,
                        profileLink: r.authorUrl,
                        rating: r.rating ?? 0,
                      );
                    }).toList();

                    final hostel = HostelModel(
                      id: placeId,
                      name: placeDetails?.name ?? "Unnamed Hostel",
                      location: placeDetails?.vicinity ?? "Unknown",
                      rating: placeDetails?.rating ?? 3.5,
                      totalRatings: placeDetails?.userRatingsTotal ?? 0,
                      photos: photos.isEmpty ? [imageUrl] : photos,
                      amenities: generateAmenities(placeDetails?.types ?? []),
                      overview: "Comfortable and affordable student hostel.",
                      reviews: reviews,
                      phoneNumber: placeDetails!.formattedPhoneNumber,
                    );

                    if (context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HostelDetail(hostel: hostel),
                        ),
                      );
                    }
                  },
                  child: FutureBuilder<HostelModel>(
                    future: _convertToHostelModel(place),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        return PopularHostelCard(hostel: snapshot.data!);
                      } else {
                        return const SizedBox(
                          width: 220,
                          height: 250,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        /// ---- View All Button ----
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0),
          child: ViewAllHostelsButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AllHostels(
                    headerString: CustomAppStrings.nearbyHostelsString,
                  ),
                ),
              );
            },
          ),
        ),

        /// ---- Nearby Hostels (Vertical List) ----
        Column(
          children: hostels.map((place) {
            return FutureBuilder<HostelModel>(
              future: _convertToHostelModel(place),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => HostelDetail(hostel: snapshot.data!),
                        ),
                      );
                    },
                    child: NearbyHostels(hostel: snapshot.data!),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<HostelModel> _convertToHostelModel(SearchResult place) async {
    final placeId = place.placeId!;
    final details = await _googlePlace.details.get(placeId);
    final placeDetails = details?.result;

    final photoRef = place.photos?.firstOrNull?.photoReference;
    final fallbackImage = photoRef != null
        ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=${dotenv.env['GOOGLE_API_KEY']}"
        : "assets/icons/app/app-icon.png";

    final photos = (placeDetails?.photos ?? []).map((photo) {
      return "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=${photo.photoReference}&key=${dotenv.env['GOOGLE_API_KEY']}";
    }).toList();

    final reviews = (placeDetails?.reviews ?? []).map((r) {
      return ReviewModel(
        reviewerName: r.authorName ?? "Anonymous",
        reviewDate: r.relativeTimeDescription ?? "Unknown Date",
        reviewText: r.text ?? "",
        profilePhotoUrl: r.profilePhotoUrl,
        profileLink: r.authorUrl,
        rating: r.rating ?? 0,
      );
    }).toList();

    return HostelModel(
      id: placeId,
      name: placeDetails?.name ?? "Unnamed Hostel",
      location: placeDetails?.vicinity ?? "Unknown",
      rating: placeDetails?.rating ?? 3.5,
      totalRatings: placeDetails?.userRatingsTotal ?? 0,
      photos: photos.isEmpty ? [fallbackImage] : photos,
      amenities: generateAmenities(placeDetails?.types ?? []),
      overview: "Comfortable and affordable student hostel.",
      reviews: reviews,
      phoneNumber: placeDetails?.formattedPhoneNumber,
    );
  }
}
