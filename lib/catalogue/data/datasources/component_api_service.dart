import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/component_model.dart';

class ComponentApiService {
  final String baseUrl;

  ComponentApiService({this.baseUrl = 'https://backend-5l98.onrender.com/api/v1/catalogue'});

  /// GET /api/v1/catalogue?name=&type=&categoryId=&manufacturerId=
  Future<List<ComponentModel>> fetchComponents({
    String? name,
    String? type,
    int? categoryId,
    int? manufacturerId,
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      if (name != null && name.isNotEmpty) 'name': name,
      if (type != null && type.isNotEmpty) 'type': type,
      if (categoryId != null) 'categoryId': categoryId.toString(),
      if (manufacturerId != null) 'manufacturerId': manufacturerId.toString(),
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonList =
      json.decode(utf8.decode(response.bodyBytes));
      return jsonList.map((json) => ComponentModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener componentes: ${response.statusCode}');
    }
  }

  /// POST /api/v1/catalogue
  Future<ComponentModel> createComponent(ComponentModel component) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(component.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ComponentModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear componente: ${response.statusCode}');
    }
  }

  /// PUT /api/v1/catalogue/{id}
  Future<void> updateComponent(int id, ComponentModel component) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(component.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar componente: ${response.statusCode}');
    }
  }

  /// DELETE /api/v1/catalogue/{id}
  Future<void> deleteComponent(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar componente: ${response.statusCode}');
    }
  }
}