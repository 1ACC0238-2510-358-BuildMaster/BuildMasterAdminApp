import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/manufacturer_model.dart';

class ManufacturerApiService {
  final String baseUrl;

  ManufacturerApiService({this.baseUrl = 'http://10.0.2.2:8080/api/manufacturers'});

  /// GET /api/manufacturers
  Future<List<ManufacturerModel>> fetchManufacturers() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ManufacturerModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener fabricantes: ${response.statusCode}');
    }
  }

  /// POST /api/manufacturers
  Future<ManufacturerModel> createManufacturer(ManufacturerModel manufacturer) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(manufacturer.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ManufacturerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear fabricante: ${response.statusCode}');
    }
  }

  /// DELETE /api/manufacturers/{id}
  Future<void> deleteManufacturer(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar fabricante: ${response.statusCode}');
    }
  }
}