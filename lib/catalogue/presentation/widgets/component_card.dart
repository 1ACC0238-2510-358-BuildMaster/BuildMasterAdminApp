import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/component.dart';
import '../providers/build_provider.dart';

class ComponentCard extends StatelessWidget {
  final Component component;
  final int currentCategoryId;

  const ComponentCard({
    super.key,
    required this.component,
    required this.currentCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    final buildProvider = Provider.of<BuildProvider>(context);
    final selectedId = buildProvider.getSelectedComponent(currentCategoryId);
    final isSelected = selectedId == component.id;

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          buildProvider.deselectComponent(currentCategoryId);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${component.name} deseleccionado de la build'),
              duration: const Duration(seconds: 1),
            ),
          );
        } else {
          buildProvider.selectComponent(currentCategoryId, component.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${component.name} seleccionado para la build'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Card(
        color: isSelected ? Colors.green[100] : null,
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(component.name),
          subtitle: Text(
            'Tipo: ${component.type} | \$${component.price.toStringAsFixed(2)}',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(component.manufacturer.name),
              Text(component.category.name),
            ],
          ),
        ),
      ),
    );
  }
}
