import '../entities/category.dart';
import '../repositories/catalogue_repository.dart';

class CreateCategoryUseCase {
  final CatalogueRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<Category> call(Category category) {
    return repository.createCategory(category);
  }
}
