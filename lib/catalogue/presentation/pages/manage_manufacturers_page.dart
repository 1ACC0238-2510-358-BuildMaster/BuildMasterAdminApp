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
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController supportEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogueProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Fabricantes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del fabricante',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: websiteController,
                  decoration: const InputDecoration(
                    labelText: 'Sitio web',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: supportEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo de soporte',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final website = websiteController.text.trim();
                    final email = supportEmailController.text.trim();

                    if (name.isNotEmpty && website.isNotEmpty && email.isNotEmpty) {
                      final newManu = ManufacturerModel(
                        id: 0,
                        name: name,
                        website: website,
                        supportEmail: email,
                      ).toEntity();

                      await provider.createManufacturer(newManu);

                      nameController.clear();
                      websiteController.clear();
                      supportEmailController.clear();
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: provider.manufacturers.length,
              itemBuilder: (context, index) {
                final manu = provider.manufacturers[index];
                return ListTile(
                  title: Text(manu.name),
                  subtitle: Text('${manu.website} | ${manu.supportEmail}'),
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