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
  }) {
    selectedType = type;
    selectedCategoryId = categoryId;
    selectedManufacturerId = manufacturerId;
    searchName = name;
    fetchComponents();
  }
}