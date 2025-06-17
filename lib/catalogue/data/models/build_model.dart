class BuildModel {
  final Map<int, int> _selectedComponents = {}; // categoryId -> componentId

  void selectComponent({required int categoryId, required int componentId}) {
    _selectedComponents[categoryId] = componentId;
  }

  int? getComponentForCategory(int categoryId) {
    return _selectedComponents[categoryId];
  }

  void removeComponent(int categoryId) {
    _selectedComponents.remove(categoryId);
  }

  void deselectComponent(int categoryId) {
    _selectedComponents.remove(categoryId);
  }

  void clear() {
    _selectedComponents.clear();
  }

  Map<int, int> get selectedComponents => _selectedComponents;
}