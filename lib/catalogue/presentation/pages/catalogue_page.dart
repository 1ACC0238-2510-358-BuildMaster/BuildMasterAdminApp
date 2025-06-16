import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalogue_provider.dart';
import '../widgets/component_card.dart';

class CataloguePage extends StatelessWidget {
  const CataloguePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogueProvider>(context);
    for (var cat in provider.categories) {
      print('Categoría: ${cat.name}');
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
                  items: [ // Se tiene que respetar esto para alivar la carga tanto en front como en back
                    'Alta',
                    'Media',
                    'Baja'
                  ]
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) => provider.updateFilters(type: value),
                ),
                DropdownButton<int>(
                  value: provider.selectedCategoryId,
                  hint: const Text("Categoría"),
                  items: provider.categories
                      .map((cat) => DropdownMenuItem(
                    value: cat.id,
                    child: Text('${cat.name}', style: const TextStyle(fontFamily: 'Roboto')),
                  ))
                      .toList(),
                  onChanged: (value) =>
                      provider.updateFilters(categoryId: value),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}