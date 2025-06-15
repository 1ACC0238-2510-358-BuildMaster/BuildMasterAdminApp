import 'package:flutter/material.dart';

class FilterDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<T> items;
  final String Function(T) labelBuilder;
  final void Function(T?) onChanged;

  const FilterDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      hint: Text(hint),
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(labelBuilder(item)),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }
}