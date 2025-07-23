import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:hostel_finder/core/custom_scaffold_body.dart';
import 'package:hostel_finder/core/premium_scaffold.dart';
import 'package:hostel_finder/features/all_hostels/all_hostels.dart';
import 'package:hostel_finder/features/home/widgets/app_hostel_location.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostels.dart';
import 'package:hostel_finder/features/home/widgets/salutation.dart';
import 'package:hostel_finder/shared/app_strings/custom_app_strings.dart';
import 'package:hostel_finder/shared/text_fields/custom_app_search_bar.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:get/get.dart';

import '../favorites/controllers/favorites_controller.dart';
import '../favorites/favorites.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final controller = Get.find<FavoritesController>();

  late GooglePlace _googlePlace;
  List<SearchResult> _hostelResults = [];
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GOOGLE_API_KEY']!;
    _googlePlace = GooglePlace(apiKey);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    _searchNearbyHostels();
  }

  Future<void> _searchNearbyHostels() async {
    if (_currentPosition == null) return;

    final result = await _googlePlace.search.getNearBySearch(
      Location(
        lat: _currentPosition!.latitude,
        lng: _currentPosition!.longitude,
      ),
      100_000, // Slightly larger radius
      // keyword: "hostel",
      // Removed type: "lodging" to allow broader matches
    );



    if (result != null && result.results != null) {
      final hostelsLikely = result.results!.where((place) {
        final name = place.name?.toLowerCase() ?? '';
        final types = place.types?.join(',').toLowerCase() ?? '';
        return name.contains("hostel") || types.contains("lodging");
      }).toList();


      for (var place in hostelsLikely) {
        debugPrint('Found: ${place.name}');
      }


      setState(() {
        _hostelResults = hostelsLikely;
      });
    } else {
      setState(() {
        _hostelResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PremiumScaffold(
        showSearchBar: true,
        onSearchTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => AllHostels(
              headerString: CustomAppStrings.recentSearchString,
            ),
          ),
        ),
        leading: const AppHostelLocation(location: "Adenta Municipality", color: Colors.white54),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _hostelResults.isEmpty
                  ? const Center(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: CircularProgressIndicator(),
                  ))
                  : PopularHostels(hostels: _hostelResults),
            ],
          ),
        ),
      ),

        floatingActionButton: Obx(() {
          return controller.favorites.isNotEmpty
              ? FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            label: const Text("Favorites"),
            backgroundColor: Colors.redAccent,
          )
              : const SizedBox.shrink(); // or just return null if you prefer
        }),// or just return null if you prefer
    );
  }
}
