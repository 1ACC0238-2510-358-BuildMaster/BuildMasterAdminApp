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
    return Consumer<BuildProvider>(
      builder: (context, buildProvider, _) {
        final selectedId = buildProvider.getSelectedComponent(currentCategoryId);
        final isSelected = selectedId == component.id;
        print('[DEBUG] Component ID: ${component.id}, Category ID: $currentCategoryId, SelectedID: $selectedId, isSelected: $isSelected');
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              buildProvider.deselectComponent(currentCategoryId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${component.name} deseleccionado de la build')),
              );
            } else {
              buildProvider.selectComponent(currentCategoryId, component.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${component.name} seleccionado para la build')),
              );
            }
          },
          child: Card(
            color: isSelected ? Colors.green : Colors.white,
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected ? Colors.green.shade900 : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    component.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tipo: ${component.type} | \$${component.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        component.manufacturer.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                      Text(
                        component.category.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}