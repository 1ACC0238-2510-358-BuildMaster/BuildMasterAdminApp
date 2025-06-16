import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category_model.dart';

class CategoryApiService {
  final String baseUrl;

  CategoryApiService({this.baseUrl = 'http://10.0.2.2:8080/api/categories'});

  /// GET /api/categories
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener categorías: ${response.statusCode}');
    }
  }

  /// POST /api/categories
  Future<CategoryModel> createCategory(CategoryModel category) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(category.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return CategoryModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear categoría: ${response.statusCode}');
    }
  }

  /// DELETE /api/categories/{id}
  Future<void> deleteCategory(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar categoría: ${response.statusCode}');
    }
  }
}
