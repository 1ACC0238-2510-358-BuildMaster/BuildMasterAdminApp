import 'category.dart';
import 'manufacturer.dart';

class Component {
  final int id;
  final String name;
  final String type;
  final double price;
  final Specifications specifications;
  final Category category;
  final Manufacturer manufacturer;

  Component({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.specifications,
    required this.category,
    required this.manufacturer,
  });

  Component copyWith({
    int? id,
    String? name,
    String? type,
    double? price,
    Specifications? specifications,
    Category? category,
    Manufacturer? manufacturer,
  }) {
    return Component(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      specifications: specifications ?? this.specifications,
      category: category ?? this.category,
      manufacturer: manufacturer ?? this.manufacturer,
    );
  }
}

class Specifications {
  final String socket;
  final String memoryType;
  final int powerConsumptionWatts;
  final String formFactor;

  Specifications({
    required this.socket,
    required this.memoryType,
    required this.powerConsumptionWatts,
    required this.formFactor,
  });

  Specifications copyWith({
    String? socket,
    String? memoryType,
    int? powerConsumptionWatts,
    String? formFactor,
  }) {
    return Specifications(
      socket: socket ?? this.socket,
      memoryType: memoryType ?? this.memoryType,
      powerConsumptionWatts: powerConsumptionWatts ?? this.powerConsumptionWatts,
      formFactor: formFactor ?? this.formFactor,
    );
  }
}