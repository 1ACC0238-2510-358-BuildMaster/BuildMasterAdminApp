import 'package:flutter/material.dart';
import '../../domain/entities/component.dart';

class EditComponentDialog extends StatefulWidget {
  final Component initialComponent;
  final Function(Component) onSave;

  const EditComponentDialog({
    super.key,
    required this.initialComponent,
    required this.onSave,
  });

  @override
  State<EditComponentDialog> createState() => _EditComponentDialogState();
}

class _EditComponentDialogState extends State<EditComponentDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialComponent.name);
    _typeController = TextEditingController(text: widget.initialComponent.type);
    _priceController = TextEditingController(
      text: widget.initialComponent.price.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Componente'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            // Aquí puedes agregar más campos según necesites
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  void _saveChanges() {
    final updatedComponent = widget.initialComponent.copyWith(
      name: _nameController.text,
      type: _typeController.text,
      price: double.tryParse(_priceController.text) ?? 0,
    );
    widget.onSave(updatedComponent);
    Navigator.pop(context);
  }
}