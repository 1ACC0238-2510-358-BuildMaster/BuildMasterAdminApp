import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../../data/datasources/category_api_service.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({super.key});

  @override
  State<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  late final CategoryApiService _apiService;
  late Future<List<CategoryModel>> _categories;

  @override
  void initState() {
    super.initState();
    _apiService = CategoryApiService();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _categories = _apiService.fetchCategories();
    });
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Categoría'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nombre'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      await _apiService.createCategory(CategoryModel(id: 0, name: result.trim()));
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Categorías')),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: \${snapshot.error}'));
          }
          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final category = categories[index];
              return ListTile(
                title: Text(category.name),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await _apiService.deleteCategory(category.id);
                    _refresh();
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}