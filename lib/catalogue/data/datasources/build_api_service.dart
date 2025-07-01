import 'dart:convert';
import 'package:http/http.dart' as http;

class BuildApiService {
  final String baseUrl;

  BuildApiService({this.baseUrl = 'http://10.0.2.2:8080/api/builds'});

  Future<http.Response> createBuild(List<int> componentIds) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'componentIds': componentIds}),
    );
    return response;
  }
}
