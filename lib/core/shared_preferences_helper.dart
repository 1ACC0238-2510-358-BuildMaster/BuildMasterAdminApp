import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SharedPrefsHelper {
  static const _keySavedBuilds = 'saved_builds';

  static Future<void> saveBuildId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList(_keySavedBuilds) ?? [];
    savedIds.add(id.trim());
    await prefs.setStringList(_keySavedBuilds, savedIds);
  }
  static Future<List<String>> getSavedBuildIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySavedBuilds) ?? [];
  }
  static Future<void> removeBuildId(String buildId) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> builds = prefs.getStringList(_keySavedBuilds) ?? [];

    debugPrint('🗂️ Antes de borrar: $builds');

    final cleanedId = buildId.trim();
    builds.removeWhere((id) => id.trim() == cleanedId);

    debugPrint('🗂️ Después de borrar: $builds');

    await prefs.setStringList(_keySavedBuilds, builds);

    debugPrint('✅ Guardado nuevo SharedPrefs.');
  }

  static Future<List<String>> getBuildIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keySavedBuilds) ?? [];
  }
}