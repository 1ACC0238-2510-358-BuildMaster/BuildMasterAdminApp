class BuildModel {
  final Map<int, int> selectedComponentsByCategory;
  BuildModel({Map<int, int>? selectedComponentsByCategory})
      : selectedComponentsByCategory = selectedComponentsByCategory ?? {};
  final Map<int, int> selectedComponents = {}; // categoryId -> componentId

  void selectComponent({required int categoryId, required int componentId}) {
    selectedComponents[categoryId] = componentId;
  }

  int? getComponentForCategory(int categoryId) {
    return selectedComponentsByCategory[categoryId];
  }

  void removeComponent(int categoryId) {
    selectedComponentsByCategory.remove(categoryId);
  }

  void deselectComponent(int categoryId) {
    selectedComponents.remove(categoryId);
  }
  void clear() {
    selectedComponentsByCategory.clear();
  }
}
