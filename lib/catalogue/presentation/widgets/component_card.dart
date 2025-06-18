import 'package:flutter/material.dart';
import '../../domain/entities/component.dart';

class ComponentCard extends StatelessWidget {
  final Component component;

  const ComponentCard({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(component.name),
        subtitle: Text('Tipo: ${component.type} | \$${component.price.toStringAsFixed(2)}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(component.manufacturer.name),
            Text(component.category.name),
          ],
        ),
      ),
    );
  }
}