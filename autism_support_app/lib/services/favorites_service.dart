import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorite_tips';
  static const String _favoriteFeelingsKey = 'favorite_feelings';
  static const String _favoriteNeedsKey = 'favorite_needs';
  static const String _favoriteThoughtsKey = 'favorite_thoughts';

  static Future<Set<String>> getFavoriteTips() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.toSet();
  }

  static Future<void> toggleFavoriteTip(String tipTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (favorites.contains(tipTitle)) {
      favorites.remove(tipTitle);
    } else {
      favorites.add(tipTitle);
    }
    await prefs.setStringList(_favoritesKey, favorites);
  }

  static Future<Set<String>> getFavoriteFeelings() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteFeelingsKey) ?? [];
    return favorites.toSet();
  }

  static Future<void> toggleFavoriteFeeling(String feelingName) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteFeelingsKey) ?? [];
    if (favorites.contains(feelingName)) {
      favorites.remove(feelingName);
    } else {
      favorites.add(feelingName);
    }
    await prefs.setStringList(_favoriteFeelingsKey, favorites);
  }

  static Future<Set<String>> getFavoriteNeeds() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteNeedsKey) ?? [];
    return favorites.toSet();
  }

  static Future<void> toggleFavoriteNeed(String needName) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteNeedsKey) ?? [];
    if (favorites.contains(needName)) {
      favorites.remove(needName);
    } else {
      favorites.add(needName);
    }
    await prefs.setStringList(_favoriteNeedsKey, favorites);
  }

  static Future<Set<String>> getFavoriteThoughts() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteThoughtsKey) ?? [];
    return favorites.toSet();
  }

  static Future<void> toggleFavoriteThought(String thoughtName) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteThoughtsKey) ?? [];
    if (favorites.contains(thoughtName)) {
      favorites.remove(thoughtName);
    } else {
      favorites.add(thoughtName);
    }
    await prefs.setStringList(_favoriteThoughtsKey, favorites);
  }
}
