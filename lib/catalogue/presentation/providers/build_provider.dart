import 'package:flutter/material.dart';
import '../../data/models/build_model.dart';

class BuildProvider extends ChangeNotifier {
  BuildModel _currentBuild = BuildModel();

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
}


