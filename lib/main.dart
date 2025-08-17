
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:hostel_finder/core/app_routes.dart';
// import 'package:hostel_finder/firebase_options.dart';

import 'features/auth/controller/auth_controller.dart';
import 'features/favorites/controllers/favorites_controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity
  );

  await dotenv.load();

  Get.put(FavoritesController());
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
      ),
      initialRoute: AppRoutes.loginScreen,
      // initialRoute: AppRoutes.homeScreen,
      routes: AppRoutes.routes,
    );
  }
}

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  late GoogleMapController _mapController;
  String? _mapStyle;
  final Set<Marker> _markers = {};
  LatLng? currentPosition;
  late GooglePlace _googlePlace;
  List<SearchResult> _hostelResults = [];

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['GOOGLE_API_KEY']!;
    _googlePlace = GooglePlace(apiKey);

    //Load map custom style
    rootBundle.loadString("assets/map_styles/hostel_only_map_style.json").then((value) {
      _mapStyle = value;
    });

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    );
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });
    _searchNearbyHostels();
  }

  Future<void> _searchNearbyHostels() async {
    if (currentPosition == null) return;

    final result = await _googlePlace.search.getNearBySearch(
      Location(
        lat: currentPosition!.latitude,
        lng: currentPosition!.longitude,
      ),
      20000, // Slightly larger radius
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
        _markers.clear();
        for (var place in hostelsLikely) {
          final loc = place.geometry?.location;
          if (loc != null) {
            _markers.add(
              Marker(
                markerId: MarkerId(place.placeId!),
                position: LatLng(loc.lat!, loc.lng!),
                infoWindow: InfoWindow(
                  title: place.name,
                  snippet: place.vicinity,
                ),
              ),
            );
          }
        }
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
      appBar: AppBar(title: const Text("Hostel Finder")),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              style: _mapStyle,
              initialCameraPosition: CameraPosition(
                target: currentPosition!,
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}

