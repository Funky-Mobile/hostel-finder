import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/data/hostel_model.dart';

class FavoritesController extends GetxController {
  static const String _favoritesKey = 'FAVORITE_HOSTELS';

  final RxList<HostelModel> _favorites = <HostelModel>[].obs;
  List<HostelModel> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_favoritesKey) ?? [];

    _favorites.assignAll(
        saved.map((json) => HostelModel.fromJson(jsonDecode(json))).toList()
    );
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved =
    _favorites.map((hostel) => jsonEncode(hostel.toJson())).toList();

    await prefs.setStringList(_favoritesKey, saved);
  }

  void toggleFavorite(HostelModel hostel) {
    if (isFavorite(hostel)) {
      _favorites.removeWhere((h) => h.id == hostel.id);
    } else {
      _favorites.add(hostel);
    }
    _saveFavorites();
  }

  bool isFavorite(HostelModel hostel) {
    return _favorites.any((h) => h.id == hostel.id);
  }
}
