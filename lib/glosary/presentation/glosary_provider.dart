import 'package:flutter/material.dart';
import '../data/glosary_api_service.dart';

class GlosaryProvider extends ChangeNotifier {
  final GlosaryApiService apiService;
  List<Map<String, dynamic>> glosarioFacil = [];
  Map<String, List<String>> consejosUtiles = {};
  bool isLoading = false;
  String? error;

  GlosaryProvider({required this.apiService});

  List<Map<String, dynamic>> _allGlosarioFacil = [];

  Future<void> fetchGlosary() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final data = await apiService.fetchGlosary();
      _allGlosarioFacil = List<Map<String, dynamic>>.from(data['glosario_facil'] ?? []);
      glosarioFacil = List<Map<String, dynamic>>.from(_allGlosarioFacil);
      consejosUtiles = Map<String, List<String>>.from(
        (data['consejos_utiles'] ?? {}).map((k, v) => MapEntry(k, List<String>.from(v)))
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void filterByPalabra(String palabra) {
    if (palabra.isEmpty) {
      glosarioFacil = List<Map<String, dynamic>>.from(_allGlosarioFacil);
    } else {
      final q = palabra.toLowerCase();
      glosarioFacil = _allGlosarioFacil.where((item) {
        final p = (item['palabra'] ?? '').toString().toLowerCase();
        return p.contains(q);
      }).toList();
    }
    notifyListeners();
  }
}
