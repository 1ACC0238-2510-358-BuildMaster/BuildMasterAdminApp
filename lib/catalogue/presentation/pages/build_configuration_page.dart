import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalogue_provider.dart';
import '../providers/build_provider.dart';
import 'catalogue_page.dart';
import 'admin_panel_page.dart';
import 'saved_builds_page.dart';

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
      provider.loadInitialData();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Modo Admin',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminPanelPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // COMPONENTES SELECCIONADOS ARRIBA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade200,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TÍTULO + BOTÓN RESET
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categorias de componentes:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        buildProvider.resetBuild();
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Resetear'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        textStyle: const TextStyle(fontSize: 14),
                      ),
                    )
                  ],
                ),
                /*const SizedBox(height: 4),
                if (buildProvider.selectedComponents.isEmpty)
                  const Text('No se ha seleccionado ningún componente.')
                else
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: buildProvider.selectedComponents.entries.map((entry) {
                      final category = categories.firstWhere((c) => c.id == entry.key);
                      return Chip(
                        label: Text('${category.name} (ID: ${entry.value})'),
                        backgroundColor: Colors.green.shade100,
                      );
                    }).toList(),
                  ),*/
              ],
            ),
          ),

          // GRID DE CATEGORÍAS
          Expanded(
            child: categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.8,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = buildProvider.getSelectedComponent(category.id) != null;

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
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: isSelected ? Colors.green.shade300 : Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14, // más chico
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
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              heroTag: 'save_build_btn',
              onPressed: () async {
                if (buildProvider.selectedComponents.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Selecciona los 8 componentes antes de guardar.')),
                  );
                  return;
                }

                await buildProvider.saveBuild();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Build enviada al backend')),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Guardar Build'),
              backgroundColor: Colors.green,
            ),
            const SizedBox(height: 16),
            FloatingActionButton.extended(
              heroTag: 'view_builds_btn',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedBuildsPage()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Ver Builds Guardadas'),
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}