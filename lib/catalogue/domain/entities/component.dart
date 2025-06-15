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
}