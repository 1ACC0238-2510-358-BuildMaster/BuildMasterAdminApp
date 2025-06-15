import '../entities/component.dart';
import '../repositories/catalogue_repository.dart';

class CreateComponentUseCase {
  final CatalogueRepository repository;

  CreateComponentUseCase(this.repository);

  Future<Component> call(Component component) {
    return repository.createComponent(component);
  }
}
