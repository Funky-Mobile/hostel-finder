import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../room/dao/room_dao.dart';

class FavoritesController extends GetxController {
  static const String _favoritesKey = 'FAVORITE_ROOMS';

  final RxList<RoomDao> _favorites = <RoomDao>[].obs;
  List<RoomDao> get favorites => _favorites;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved = prefs.getStringList(_favoritesKey) ?? [];

    _favorites.assignAll(
      saved.map((json) => RoomDao.fromJson(jsonDecode(json))).toList(),
    );
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> saved =
    _favorites.map((room) => jsonEncode(room.toJson())).toList();

    await prefs.setStringList(_favoritesKey, saved);
  }

  void toggleFavorite(RoomDao room) {
    if (isFavorite(room)) {
      _favorites.removeWhere((r) => r.id == room.id);
    } else {
      _favorites.add(room);
    }
    _saveFavorites();
  }

  bool isFavorite(RoomDao room) {
    return _favorites.any((r) => r.id == room.id);
  }
}
