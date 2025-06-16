import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required int id,
    required String name,
    String? parent,
  }) : super(
    id: id,
    name: name,
    parent: parent,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      parent: json['parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent': parent,
    };
  }

  static CategoryModel fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      parent: category.parent,
    );
  }

  Category toEntity() => this;
}
