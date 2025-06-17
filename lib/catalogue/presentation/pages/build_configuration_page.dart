import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalogue_provider.dart';
import '../providers/build_provider.dart';
import 'catalogue_page.dart';

class BuildConfiguratorPage extends StatefulWidget {
  const BuildConfiguratorPage({super.key});

  @override
  State<BuildConfiguratorPage> createState() => _BuildConfiguratorPageState();
}

class _BuildConfiguratorPageState extends State<BuildConfiguratorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CatalogueProvider>(context, listen: false);
      if (provider.categories.isEmpty) {
        provider.loadInitialData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final catalogueProvider = Provider.of<CatalogueProvider>(context);
    final buildProvider = Provider.of<BuildProvider>(context);
    final categories = catalogueProvider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configura tu Build'),
      ),
      body: Column(
        children: [
          Expanded(
            child: categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = buildProvider.getSelectedComponent(
                    category.id) != null;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CataloguePage(categoryId: category.id),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: isSelected ? Colors.green.shade300 : Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Barra inferior con selección
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey.shade200,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Componentes seleccionados:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (buildProvider.selectedComponents.isEmpty)
                  const Text('No se ha seleccionado ningún componente.')
                else
                  Wrap(
                    spacing: 8.0,
                    children: buildProvider.selectedComponents.entries.map((
                        entry) {
                      final category = categories.firstWhere((c) =>
                      c.id == entry.key);
                      return Chip(
                        label: Text('${category.name} (ID: ${entry.value})'),
                        backgroundColor: Colors.green.shade100,
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}