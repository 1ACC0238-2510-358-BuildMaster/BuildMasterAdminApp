import '../entities/component.dart';
import '../repositories/catalogue_repository.dart';

class UpdateComponentUseCase {
  final CatalogueRepository repository;

  UpdateComponentUseCase(this.repository);

  Future<void> call(int id, Component component) {
    return repository.updateComponent(id, component);
  }
}