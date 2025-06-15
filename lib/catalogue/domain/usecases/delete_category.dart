import '../repositories/catalogue_repository.dart';

class DeleteCategoryUseCase {
  final CatalogueRepository repository;

  DeleteCategoryUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteCategory(id);
  }
}