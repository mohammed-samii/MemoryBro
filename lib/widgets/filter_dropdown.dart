  // Dropdown for Genre and Mood
  // ignore_for_file: unused_element

  import 'package:flutter/material.dart';

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Expanded(
      child: DropdownButton<String>(
        isExpanded: true,
        value: value,
        hint: Text(label),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        dropdownColor: const Color.fromARGB(255, 47, 47, 47),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }