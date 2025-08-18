import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hostel_finder/core/app_routes.dart';

import 'core/cache/token_cache_service.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/favorites/controllers/favorites_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  await dotenv.load();

  Get.put(FavoritesController());
  Get.put(AuthController());

  // check for token
  final token = await TokenCacheService.getToken();
  final initialRoute =
  token != null && token.isNotEmpty ? AppRoutes.homeScreen : AppRoutes.loginScreen;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute,
      routes: AppRoutes.routes,
    );
  }
}