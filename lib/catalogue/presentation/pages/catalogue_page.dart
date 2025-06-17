import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalogue_provider.dart';
import '../widgets/component_card.dart';

class CataloguePage extends StatelessWidget {
  final int categoryId;

  const CataloguePage({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogueProvider>(context);

    if (provider.selectedCategoryId != categoryId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.resetFiltersWithCategory(categoryId);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Componentes')),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    DropdownButton<String>(
                      value: provider.selectedType,
                      hint: const Text("Tipo"),
                      items: ['Alta', 'Media', 'Baja']
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList(),
                      onChanged: (value) {
                        final trimmed = value?.trim();
                        provider.updateFilters(
                            type:
                            (trimmed == null || trimmed.isEmpty) ? null : trimmed);
                      },
                    ),
                    DropdownButton<int>(
                      value: provider.selectedManufacturerId,
                      hint: const Text("Fabricante"),
                      items: provider.manufacturers
                          .map((manu) => DropdownMenuItem(
                        value: manu.id,
                        child: Text(manu.name),
                      ))
                          .toList(),
                      onChanged: (value) =>
                          provider.updateFilters(manufacturerId: value),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => provider.resetFilters(),
                      icon: const Icon(Icons.clear),
                      label: const Text("Quitar filtros"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 300, // Puedes usar MediaQuery para hacerlo responsive
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nombre',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    ),
                    onChanged: (value) =>
                        provider.updateFilters(name: value),
                  ),
                ),
              ],
            ),
          ),
          // Resultados
          provider.isLoading
              ? const CircularProgressIndicator()
              : Expanded(
            child: ListView.builder(
              itemCount: provider.components.length,
              itemBuilder: (_, index) => ComponentCard(
                component: provider.components[index],
                currentCategoryId: categoryId,
              ),
            ),
          ),
        ],
      ),
    );
  }
}