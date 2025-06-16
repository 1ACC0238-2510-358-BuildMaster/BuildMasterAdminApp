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
        provider.updateFilters(categoryId: categoryId);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Componentes')),
      body: Column(
        children: [
          // Filtros
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
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
                  onChanged: (value) => provider.updateFilters(type: value),
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
                SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Buscar por nombre',
                      border: OutlineInputBorder(),
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
