import '../entities/manufacturer.dart';
import '../repositories/catalogue_repository.dart';

class GetManufacturersUseCase {
  final CatalogueRepository repository;

  GetManufacturersUseCase(this.repository);

  Future<List<Manufacturer>> call() {
    return repository.getManufacturers();
  }
}
