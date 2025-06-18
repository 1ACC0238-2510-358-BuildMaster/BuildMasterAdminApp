import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/component_model.dart';
import '../../domain/entities/component.dart';
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
  int? _editingComponentId; // Nuevo: para controlar si estamos editando

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CatalogueProvider>(context, listen: false);
      provider.loadInitialData(); // Ya la tienes
      provider.clearFilters();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _socketController.dispose();
    _memoryTypeController.dispose();
    _powerController.dispose();
    _formFactorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Nuevo método: Cargar datos del componente en el formulario
  void _loadComponentData(Component component) {
    _nameController.text = component.name;
    _typeController.text = component.type;
    _priceController.text = component.price.toString();
    _selectedCategoryId = component.category.id;
    _selectedManufacturerId = component.manufacturer.id;
    _socketController.text = component.specifications.socket;
    _memoryTypeController.text = component.specifications.memoryType;
    _powerController.text = component.specifications.powerConsumptionWatts.toString();
    _formFactorController.text = component.specifications.formFactor;
    _editingComponentId = component.id;
  }

  // Nuevo método: Limpiar el formulario
  void _clearForm() {
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
      _editingComponentId = null;
    });
  }

  // Método modificado: Ahora maneja tanto creación como actualización
  Future<void> _saveComponent() async {
    if (_selectedCategoryId == null || _selectedManufacturerId == null) return;

    final provider = Provider.of<CatalogueProvider>(context, listen: false);

    // Convertir a entidad Component antes de guardar
    final componentEntity = Component(
      id: _editingComponentId ?? 0,
      name: _nameController.text.trim(),
      type: _typeController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0.0,
      specifications: Specifications(
        socket: _socketController.text.trim(),
        memoryType: _memoryTypeController.text.trim(),
        powerConsumptionWatts: int.tryParse(_powerController.text.trim()) ?? 0,
        formFactor: _formFactorController.text.trim(),
      ),
      category: provider.categories.firstWhere((c) => c.id == _selectedCategoryId!),
      manufacturer: provider.manufacturers.firstWhere((m) => m.id == _selectedManufacturerId!),
    );

    try {
      if (_editingComponentId != null) {
        await provider.updateComponent(componentEntity);
      } else {
        // Si es creación, usa el método que espera ComponentModel
        final componentModel = ComponentModel.fromEntity(componentEntity);
        await provider.createComponent(componentModel);
      }
      _clearForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CatalogueProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final categories = provider.categories;
    final manufacturers = provider.manufacturers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Componentes'),
        actions: [
          if (_editingComponentId != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearForm,
              tooltip: 'Cancelar edición',
            ),
        ],
      ),
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
                onPressed: _saveComponent,
                child: Text(_editingComponentId != null ? 'Actualizar Componente' : 'Agregar Componente'),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              const Text('Lista de componentes'),
              const SizedBox(height: 12),
              ...provider.components.map(
                    (comp) => ListTile(
                  title: Text(comp.name),
                  subtitle: Text('Tipo: ${comp.type} - Precio: \$${comp.price}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _loadComponentData(comp),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => provider.deleteComponent(comp.id),
                      ),
                    ],
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