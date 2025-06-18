import '../../domain/entities/manufacturer.dart';

class ManufacturerModel extends Manufacturer {
  ManufacturerModel({
    required int id,
    required String name,
    String? website,
    String? supportEmail,
  }) : super(
    id: id,
    name: name,
    website: website,
    supportEmail: supportEmail,
  );

  factory ManufacturerModel.fromJson(Map<String, dynamic> json) {
    return ManufacturerModel(
      id: json['id'],
      name: json['name'],
      website: json['website'],
      supportEmail: json['supportEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'website': website,
      'supportEmail': supportEmail,
    };
  }

  static ManufacturerModel fromEntity(Manufacturer manufacturer) {
    return ManufacturerModel(
      id: manufacturer.id,
      name: manufacturer.name,
      website: manufacturer.website,
      supportEmail: manufacturer.supportEmail,
    );
  }

  Manufacturer toEntity() {
    return Manufacturer(
      id: id,
      name: name,
      website: website,
      supportEmail: supportEmail,
    );
  }
}
