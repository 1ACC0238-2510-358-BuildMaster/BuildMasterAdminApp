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
    required UpdateComponentUseCase updateComponentUseCase,
  })  : _createComponentUseCase = createComponentUseCase,
        _deleteComponentUseCase = deleteComponentUseCase,
        _updateComponentUseCase = updateComponentUseCase;

  List<Component> _allComponents = [];
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
    _allComponents = await getComponentsUseCase(); // Carga todo
    _applyFilters();

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchComponents() async {
    isLoading = true;
    notifyListeners();

    _allComponents = await getComponentsUseCase(); // Siempre recargamos todo
    _applyFilters();

    isLoading = false;
    notifyListeners();
  }

  void _applyFilters() {
    components = _allComponents.where((component) {
      final matchesType = selectedType == null || component.type == selectedType;
      final matchesCategory = selectedCategoryId == null || component.category.id == selectedCategoryId;
      final matchesManufacturer = selectedManufacturerId == null || component.manufacturer.id == selectedManufacturerId;
      final matchesName = searchName == null || component.name.toLowerCase().contains(searchName!.toLowerCase());
      return matchesType && matchesCategory && matchesManufacturer && matchesName;
    }).toList();
  }

  Future<void> updateFilters({
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

    _applyFilters();
    notifyListeners();
  }

  Future<void> resetFilters() async {
    selectedType = null;
    selectedManufacturerId = null;
    searchName = null;
    // Mantener categoría actual
    _applyFilters();
    notifyListeners();
  }
  void clearFilters() {
    selectedType = null;
    selectedCategoryId = null;
    selectedManufacturerId = null;
    searchName = null;
    components = List.from(_allComponents);
    notifyListeners();
  }

  Future<void> resetFiltersWithCategory(int categoryId) async {
    selectedType = null;
    selectedManufacturerId = null;
    searchName = null;
    selectedCategoryId = categoryId;
    _applyFilters();
    notifyListeners();
  }

  Future<void> createManufacturer(Manufacturer manufacturer) async {
    await createManufacturerUseCase(manufacturer);
    manufacturers = await getManufacturersUseCase();
    notifyListeners();
  }

  Future<void> deleteManufacturer(int id) async {
    await deleteManufacturerUseCase(id);
    manufacturers = await getManufacturersUseCase();
    notifyListeners();
  }

  Future<void> createComponent(ComponentModel componentModel) async {
    final entity = componentModel.toEntity();
    await _createComponentUseCase(entity);
    await fetchComponents(); // recarga todo
  }

  Future<void> updateComponent(Component component) async {
    if (component.id == null) {
      throw ArgumentError('Component must have an ID to be updated');
    }
    await _updateComponentUseCase(component.id, component);
    await fetchComponents();
  }

  Future<void> deleteComponent(int id) async {
    await _deleteComponentUseCase(id);
    await fetchComponents();
  }

  // Útil para BuildConfiguratorPage: obtener todos los componentes de una categoría, sin filtros
  List<Component> getComponentsByCategory(int categoryId) {
    return _allComponents.where((c) => c.category.id == categoryId).toList();
  }
}