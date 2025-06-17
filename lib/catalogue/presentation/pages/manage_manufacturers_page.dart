import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/manufacturer_model.dart';
import '../providers/catalogue_provider.dart';

class ManageManufacturersPage extends StatefulWidget {
  const ManageManufacturersPage({super.key});

  @override
  State<ManageManufacturersPage> createState() => _ManageManufacturersPageState();
}

class _ManageManufacturersPageState extends State<ManageManufacturersPage> {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogueProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Fabricantes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del fabricante',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      final newManu = ManufacturerModel(id: 0, name: name);
                      await provider.createManufacturer(newManu as String);
                      nameController.clear();
                    }
                  },
                  child: const Text('Agregar'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.manufacturers.length,
              itemBuilder: (context, index) {
                final manu = provider.manufacturers[index];
                return ListTile(
                  title: Text(manu.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.deleteManufacturer(manu.id!),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
