import 'package:build_master_adminapp/catalogue/domain/usecases/update_component.dart';
import 'package:flutter/material.dart';
import '../../data/models/component_model.dart';
import '../../domain/entities/component.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/manufacturer.dart';
import '../../domain/usecases/create_component.dart';
import '../../domain/usecases/delete_component.dart';
import '../../domain/usecases/get_components.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_manufacturers.dart';
import '../../domain/usecases/create_manufacturer.dart';
import '../../domain/usecases/delete_manufacturer.dart';

class CatalogueProvider extends ChangeNotifier {
  final GetComponentsUseCase getComponentsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetManufacturersUseCase getManufacturersUseCase;
  final CreateManufacturerUseCase createManufacturerUseCase;
  final DeleteManufacturerUseCase deleteManufacturerUseCase;
  final CreateComponentUseCase _createComponentUseCase;
  final DeleteComponentUseCase _deleteComponentUseCase;
  final UpdateComponentUseCase _updateComponentUseCase;

  CatalogueProvider({
    required this.getComponentsUseCase,
    required this.getCategoriesUseCase,
    required this.getManufacturersUseCase,
    required this.createManufacturerUseCase,
    required this.deleteManufacturerUseCase,
    required CreateComponentUseCase createComponentUseCase,
    required DeleteComponentUseCase deleteComponentUseCase,
    required UpdateComponentUseCase updateComponentUseCase
  }):_createComponentUseCase = createComponentUseCase,
        _deleteComponentUseCase = deleteComponentUseCase,
        _updateComponentUseCase = updateComponentUseCase;

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
  Future<void> createManufacturer(Manufacturer manufacturer) async {
    await createManufacturerUseCase(manufacturer);
    manufacturers = await getManufacturersUseCase();
    notifyListeners();
  }

  Future<void> deleteManufacturer(int id) async {
    await deleteManufacturerUseCase(id);
    manufacturers = await getManufacturersUseCase(); // recarga la lista
    notifyListeners();
  }

  Future<void> createComponent(ComponentModel componentModel) async {
    final entity = componentModel.toEntity();
    await _createComponentUseCase(entity);
    await fetchComponents(); // recargar lista
    notifyListeners();
  }

  Future<void> updateComponent(Component component) async {
    if (component.id == null) {
      throw ArgumentError('Component must have an ID to be updated');
    }
    await _updateComponentUseCase(component.id, component);
    await fetchComponents();
    notifyListeners();
  }

  Future<void> deleteComponent(int id) async {
    await _deleteComponentUseCase(id);
    await fetchComponents();
    notifyListeners();
  }
}