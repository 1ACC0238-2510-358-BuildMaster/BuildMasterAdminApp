import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/category_model.dart';
import '../../data/models/component_model.dart';
import '../../data/models/manufacturer_model.dart';
import '../../data/models/specifications_model.dart';
import '../providers/catalogue_provider.dart';

class ManageComponentsPage extends StatefulWidget {
  const ManageComponentsPage({super.key});

  @override
  State<ManageComponentsPage> createState() => _ManageComponentsPageState();
}

class _ManageComponentsPageState extends State<ManageComponentsPage> {
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _socketController = TextEditingController();
  final _memoryTypeController = TextEditingController();
  final _powerController = TextEditingController();
  final _formFactorController = TextEditingController();
  final _priceController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedManufacturerId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogueProvider>(context);
    final categories = provider.categories;
    final manufacturers = provider.manufacturers;

    return Scaffold(
      appBar: AppBar(title: const Text('Administrar Componentes')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                items: categories
                    .map((cat) => DropdownMenuItem(
                  value: cat.id,
                  child: Text(cat.name),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              DropdownButtonFormField<int>(
                value: _selectedManufacturerId,
                items: manufacturers
                    .map((manu) => DropdownMenuItem(
                  value: manu.id,
                  child: Text(manu.name),
                ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedManufacturerId = val),
                decoration: const InputDecoration(labelText: 'Fabricante'),
              ),
              const SizedBox(height: 16),
              const Text('Especificaciones'),
              TextField(
                controller: _socketController,
                decoration: const InputDecoration(labelText: 'Socket'),
              ),
              TextField(
                controller: _memoryTypeController,
                decoration: const InputDecoration(labelText: 'Tipo de Memoria'),
              ),
              TextField(
                controller: _powerController,
                decoration: const InputDecoration(labelText: 'Consumo (W)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _formFactorController,
                decoration: const InputDecoration(labelText: 'Formato'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedCategoryId == null || _selectedManufacturerId == null) return;

                  final component = ComponentModel(
                    id: 0,
                    name: _nameController.text.trim(),
                    type: _typeController.text.trim(),
                    price: double.tryParse(_priceController.text.trim()) ?? 0.0,
                    category: CategoryModel.fromEntity(
                        provider.categories.firstWhere((c) => c.id == _selectedCategoryId!)
                    ),
                    manufacturer: ManufacturerModel.fromEntity(
                        provider.manufacturers.firstWhere((m) => m.id == _selectedManufacturerId!)
                    ),
                    specifications: SpecificationsModel(
                      socket: _socketController.text.trim(),
                      memoryType: _memoryTypeController.text.trim(),
                      powerConsumptionWatts: int.tryParse(_powerController.text.trim()) ?? 0,
                      formFactor: _formFactorController.text.trim(),
                    ),
                  );

                  await provider.createComponent(component);

                  _nameController.clear();
                  _typeController.clear();
                  _priceController.clear();
                  _socketController.clear();
                  _memoryTypeController.clear();
                  _powerController.clear();
                  _formFactorController.clear();
                  setState(() {
                    _selectedCategoryId = null;
                    _selectedManufacturerId = null;
                  });
                },
                child: const Text('Agregar Componente'),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              const Text('Lista de componentes'),
              const SizedBox(height: 12),
              ...provider.components.map(
                    (comp) => ListTile(
                  title: Text(comp.name),
                  subtitle: Text('Tipo: ${comp.type}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.deleteComponent(comp.id),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}