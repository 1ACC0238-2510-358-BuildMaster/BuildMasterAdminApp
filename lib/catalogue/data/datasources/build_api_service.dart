import 'dart:convert';
import 'package:http/http.dart' as http;

class BuildApiService {
  final String baseUrl;

  BuildApiService({this.baseUrl = 'https://backend-5l98.onrender.com/api/builds'});

  Future<http.Response> createBuild(List<int> componentIds) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'componentIds': componentIds}),
    );
    return response;
  }
  Future<Map<String, dynamic>> getBuildById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('No se pudo obtener build $id');
    }
  }

  Future<Map<String, dynamic>> getBuildResult(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id/result'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('No se pudo obtener resultado de build $id');
    }
  }
  Future<void> deleteBuild(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('No se pudo eliminar la build $id del backend.');
    }
  }

}