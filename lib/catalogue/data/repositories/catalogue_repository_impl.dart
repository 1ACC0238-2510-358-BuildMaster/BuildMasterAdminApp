import '../../domain/entities/component.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/manufacturer.dart';
import '../../domain/repositories/catalogue_repository.dart';
import '../datasources/component_api_service.dart';
import '../datasources/category_api_service.dart';
import '../datasources/manufacturer_api_service.dart';
import '../models/component_model.dart';
import '../models/category_model.dart';
import '../models/manufacturer_model.dart';

class CatalogueRepositoryImpl implements CatalogueRepository {
  final ComponentApiService componentService;
  final CategoryApiService categoryService;
  final ManufacturerApiService manufacturerService;

  CatalogueRepositoryImpl({
    required this.componentService,
    required this.categoryService,
    required this.manufacturerService,
  });

  @override
  Future<List<Component>> getComponents({
    String? name,
    String? type,
    int? categoryId,
    int? manufacturerId,
  }) async {
    final models = await componentService.fetchComponents(
      name: name,
      type: type,
      categoryId: categoryId,
      manufacturerId: manufacturerId,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Component> createComponent(Component component) async {
    final model = await componentService.createComponent(
      ComponentModel.fromEntity(component),
    );
    return model.toEntity();
  }

  @override
  Future<void> updateComponent(int id, Component component) async {
    await componentService.updateComponent(id, component as ComponentModel);
  }

  @override
  Future<void> deleteComponent(int id) async {
    await componentService.deleteComponent(id);
  }

  @override
  Future<List<Manufacturer>> getManufacturers() async {
    final models = await manufacturerService.fetchManufacturers();
    return models;
  }

  @override
  Future<Manufacturer> createManufacturer(Manufacturer manufacturer) async {
    return await manufacturerService.createManufacturer(manufacturer as ManufacturerModel);
  }

  @override
  Future<void> deleteManufacturer(int id) async {
    await manufacturerService.deleteManufacturer(id);
  }

  @override
  Future<List<Category>> getCategories() async {
    final models = await categoryService.fetchCategories();
    return models;
  }

  @override
  Future<Category> createCategory(Category category) async {
    return await categoryService.createCategory(category as CategoryModel);
  }

  @override
  Future<void> deleteCategory(int id) async {
    await categoryService.deleteCategory(id);
  }
}