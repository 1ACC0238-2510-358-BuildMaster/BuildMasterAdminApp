import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/catalogue_provider.dart';
import 'catalogue_page.dart'; // Asegúrate de que la ruta sea correcta

class BuildConfiguratorPage extends StatefulWidget {
  const BuildConfiguratorPage({super.key});

  @override
  State<BuildConfiguratorPage> createState() => _BuildConfiguratorPageState();
}

class _BuildConfiguratorPageState extends State<BuildConfiguratorPage> {
  @override
  void initState() {
    super.initState();
    // Carga inicial de categorías si aún no se han cargado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CatalogueProvider>(context, listen: false);
      if (provider.categories.isEmpty) {
        provider.loadInitialData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogueProvider>(context);
    final categories = provider.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configura tu Build'),
      ),
      body: provider.categories.isEmpty
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
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
