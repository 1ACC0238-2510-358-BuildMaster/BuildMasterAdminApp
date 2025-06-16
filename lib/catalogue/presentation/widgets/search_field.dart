import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String? initialValue;
  final void Function(String) onChanged;

  const SearchField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: TextEditingController(text: initialValue),
        decoration: const InputDecoration(
          labelText: 'Buscar por nombre',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => onChanged(value.toLowerCase()),
      ),
    );
  }
}
