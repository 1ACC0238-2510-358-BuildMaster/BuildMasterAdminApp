import '../entities/component.dart';
import '../entities/category.dart';
import '../entities/manufacturer.dart';

abstract class CatalogueRepository {
  Future<List<Component>> getComponents({
    String? name,
    String? type,
    int? categoryId,
    int? manufacturerId,
  });

  Future<Component> createComponent(Component component);
  Future<void> updateComponent(int id, Component component);
  Future<void> deleteComponent(int id);

  Future<List<Manufacturer>> getManufacturers();
  Future<Manufacturer> createManufacturer(Manufacturer manufacturer);
  Future<void> deleteManufacturer(int id);

  Future<List<Category>> getCategories();
  Future<Category> createCategory(Category category);
  Future<void> deleteCategory(int id);
}