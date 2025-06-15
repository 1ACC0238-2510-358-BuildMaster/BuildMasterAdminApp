import '../entities/category.dart';
import '../repositories/catalogue_repository.dart';

class GetCategoriesUseCase {
  final CatalogueRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<Category>> call() {
    return repository.getCategories();
  }
}