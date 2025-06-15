import '../entities/component.dart';
import '../../data/models/component_model.dart';
import '../repositories/catalogue_repository.dart';

class GetComponentsUseCase {
  final CatalogueRepository repository;

  GetComponentsUseCase(this.repository);

  Future<List<Component>> call({
    String? name,
    String? type,
    int? categoryId,
    int? manufacturerId,
  }) {
    return repository.getComponents(
      name: name,
      type: type,
      categoryId: categoryId,
      manufacturerId: manufacturerId,
    );
  }
}