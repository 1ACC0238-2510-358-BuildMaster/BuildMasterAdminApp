import 'dart:convert';
import 'package:http/http.dart' as http;

class GlosaryApiService {
  static const String baseUrl = 'https://buildmaster-api-ddh3asdah2bsggfs.canadacentral-01.azurewebsites.net';

  Future<Map<String, dynamic>> fetchGlosary() async {
    final response = await http.get(
      Uri.parse('$baseUrl/glosario'),
      headers: {'accept': 'application/json'}, // No token needed
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch glosary: ${response.body}');
    }
  }
}
