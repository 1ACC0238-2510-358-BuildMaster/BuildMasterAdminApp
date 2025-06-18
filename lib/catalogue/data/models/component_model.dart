import 'category_model.dart';
import 'manufacturer_model.dart';
import 'specifications_model.dart';
import '../../domain/entities/component.dart';

class ComponentModel {
  final int id;
  final String name;
  final String type;
  final double price;
  final SpecificationsModel specifications;
  final CategoryModel category;
  final ManufacturerModel manufacturer;

  ComponentModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.specifications,
    required this.category,
    required this.manufacturer,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      price: (json['price'] as num).toDouble(),
      specifications: SpecificationsModel.fromJson(json['specifications']),
      category: CategoryModel.fromJson(json['category']),
      manufacturer: ManufacturerModel.fromJson(json['manufacturer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'price': price,
      'specifications': specifications.toJson(),
      'categoryId': category.id,
      'manufacturerId': manufacturer.id,
    };
  }

  Component toEntity() {
    return Component(
      id: id,
      name: name,
      type: type,
      price: price,
      specifications: specifications.toEntity(),
      category: category.toEntity(),
      manufacturer: manufacturer.toEntity(),
    );
  }

  static ComponentModel fromEntity(Component entity) {
    return ComponentModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      price: entity.price,
      specifications: SpecificationsModel.fromEntity(entity.specifications),
      category: CategoryModel.fromEntity(entity.category),
      manufacturer: ManufacturerModel.fromEntity(entity.manufacturer),
    );
  }

}