import '../repositories/catalogue_repository.dart';

class DeleteManufacturerUseCase {
  final CatalogueRepository repository;

  DeleteManufacturerUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deleteManufacturer(id);
  }
}