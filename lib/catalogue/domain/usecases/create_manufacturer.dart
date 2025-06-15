import '../entities/manufacturer.dart';
import '../repositories/catalogue_repository.dart';

class CreateManufacturerUseCase {
  final CatalogueRepository repository;

  CreateManufacturerUseCase(this.repository);

  Future<Manufacturer> call(Manufacturer manufacturer) {
    return repository.createManufacturer(manufacturer);
  }
}