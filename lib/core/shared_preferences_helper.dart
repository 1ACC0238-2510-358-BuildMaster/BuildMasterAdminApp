import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const _keySavedBuilds = 'saved_builds';

  static Future<void> saveBuildId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_keySavedBuilds) ?? [];
    savedIds.add(id);
    await prefs.setStringList(_keySavedBuilds, savedIds);
  }

  static Future<List<String>> getSavedBuildIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySavedBuilds) ?? [];
  }

  static Future<void> clearBuildIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keySavedBuilds);
  }
}