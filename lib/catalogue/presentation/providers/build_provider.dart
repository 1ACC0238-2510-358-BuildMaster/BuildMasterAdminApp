import 'package:flutter/material.dart';
import '../../data/models/build_model.dart';
import '../../data/datasources/build_api_service.dart';
import '../../../core/shared_preferences_helper.dart';
import 'dart:convert';

class BuildProvider extends ChangeNotifier {
  BuildModel _currentBuild = BuildModel();
  final BuildApiService apiService;
  BuildProvider({required this.apiService});
  BuildModel get currentBuild => _currentBuild;

  void selectComponent(int categoryId, int componentId) {
    final existing = _currentBuild.getComponentForCategory(categoryId);
    if (existing == componentId) {
      _currentBuild.deselectComponent(categoryId);
    } else {
      _currentBuild.selectComponent(categoryId: categoryId, componentId: componentId);
    }
    notifyListeners();
  }

  void deselectComponent(int categoryId) {
    _currentBuild.deselectComponent(categoryId);
    notifyListeners();
  }

  int? getSelectedComponent(int categoryId) {
    return _currentBuild.getComponentForCategory(categoryId);
  }

  Map<int, int> get selectedComponents => _currentBuild.selectedComponents;

  void resetBuild() {
    _currentBuild.clear();
    notifyListeners();
  }
  Future<void> saveBuild() async {
    final ids = _currentBuild.selectedComponents.values.toList();
    final response = await apiService.createBuild(ids);

    if (response.statusCode == 200) {
      debugPrint('Build guardado correctamente: ${response.body}');

      final decoded = json.decode(response.body);
      final buildId = decoded['id'].toString();

      await SharedPrefsHelper.saveBuildId(buildId);
    } else {
      debugPrint('Error al guardar build: ${response.statusCode} ${response.body}');
    }
  }
}


