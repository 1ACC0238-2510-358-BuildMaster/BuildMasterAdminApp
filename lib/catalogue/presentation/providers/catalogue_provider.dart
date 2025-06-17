import 'package:flutter/material.dart';
import '../../domain/entities/component.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/manufacturer.dart';
import '../../domain/usecases/get_components.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_manufacturers.dart';

class CatalogueProvider extends ChangeNotifier {
  final GetComponentsUseCase getComponentsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetManufacturersUseCase getManufacturersUseCase;

  CatalogueProvider({
    required this.getComponentsUseCase,
    required this.getCategoriesUseCase,
    required this.getManufacturersUseCase,
  });
  List<Component> components = [];
  List<Category> categories = [];
  List<Manufacturer> manufacturers = [];

  String? selectedType;
  int? selectedCategoryId;
  int? selectedManufacturerId;
  String? searchName;

  bool isLoading = false;

  Future<void> loadInitialData() async {
    isLoading = true;
    notifyListeners();

    categories = await getCategoriesUseCase();
    manufacturers = await getManufacturersUseCase();

    await fetchComponents();
  }

  Future<void> fetchComponents() async {
    isLoading = true;
    notifyListeners();
    components = await getComponentsUseCase(
      name: searchName,
      type: selectedType,
      categoryId: selectedCategoryId,
      manufacturerId: selectedManufacturerId,
    );

    isLoading = false;
    notifyListeners();
  }

  void updateFilters({
    String? type,
    int? categoryId,
    int? manufacturerId,
    String? name,
  }) async {
    selectedType = type ?? selectedType;
    selectedCategoryId = categoryId ?? selectedCategoryId;
    selectedManufacturerId = manufacturerId ?? selectedManufacturerId;

    if (name != null) {
      searchName = name.trim().isEmpty ? null : name.trim();
    }

    await fetchComponents();
  }



  Future<void> resetFilters() async {
    selectedType = null;
    selectedManufacturerId = null;
    searchName = null;
    // Mantén la categoría actual
    await fetchComponents();
    notifyListeners();
  }
  Future<void> resetFiltersWithCategory(int categoryId) async {
    selectedType = null;
    selectedManufacturerId = null;
    searchName = null;
    selectedCategoryId = categoryId;

    await fetchComponents();
    notifyListeners();
  }


}