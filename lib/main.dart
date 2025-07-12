import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:hostel_finder/core/app_routes.dart';
import 'package:hostel_finder/firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load();

  // runApp(const MyApp());
  runApp(const MaterialApp(
    home: MapHomeScreen(),
  ));
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
  final Set<Marker> _markers = {};
  LatLng? currentPosition;
  late GooglePlace _googlePlace;
  List<SearchResult> _hostelResults = [];

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
      currentPosition = LatLng(position.latitude, position.longitude);
    });
    _searchNearbyHostels();
  }

  Future<void> _searchNearbyHostels() async {
    if (currentPosition == null) return;

    final result = await _googlePlace.search.getNearBySearch(
      Location(lat: currentPosition!.latitude, lng: currentPosition!.longitude),
      2000,
      type: "lodging",
      keyword: "hotel",
    );

    if (result != null && result.results != null) {
      final hostelsOnly = result.results!.where((place) {
        final name = place.name?.toLowerCase() ?? '';
        final vicinity = place.vicinity?.toLowerCase() ?? '';
        return name.contains('hotel') || vicinity.contains('hotel');
      }).toList();

      setState(() {
        _hostelResults = hostelsOnly;
        _markers.clear();
        for (var place in hostelsOnly) {
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
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: currentPosition!,
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
            ),
          ),
          Expanded(
            flex: 1,
            child: _hostelResults.isEmpty
                ? const Center(child: Text("No hostels found."))
                : ListView.builder(
              itemCount: _hostelResults.length,
              itemBuilder: (context, index) {
                final place = _hostelResults[index];
                final loc = place.geometry?.location;
                return ListTile(
                  leading: const Icon(Icons.apartment),
                  title: Text(place.name ?? 'Unnamed Hostel'),
                  subtitle: Text(place.vicinity ?? ''),
                  onTap: () {
                    if (loc != null) {
                      _mapController.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(loc.lat!, loc.lng!),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

