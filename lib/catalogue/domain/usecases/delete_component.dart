import '../repositories/catalogue_repository.dart';

class DeleteComponentUseCase {
  final CatalogueRepository repository;

  DeleteComponentUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteComponent(id);
  }
}