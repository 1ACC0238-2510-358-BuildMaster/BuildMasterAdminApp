import 'package:flutter/material.dart';
import '../../data/models/build_model.dart';

class BuildProvider extends ChangeNotifier {
  BuildModel _currentBuild = BuildModel();

  BuildModel get currentBuild => _currentBuild;

  void selectComponent(int categoryId, int componentId) {
    _currentBuild.selectComponent(categoryId: categoryId, componentId: componentId);
    notifyListeners();
  }

  int? getSelectedComponent(int categoryId) {
    return _currentBuild.getComponentForCategory(categoryId);
  }

  void deselectComponent(int categoryId) {
    _currentBuild.deselectComponent(categoryId);
    notifyListeners();
  }

  void resetBuild() {
    _currentBuild.clear();
    notifyListeners();
  }
}

