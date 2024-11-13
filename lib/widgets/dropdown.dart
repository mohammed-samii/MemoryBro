import 'package:flutter/material.dart';

Widget buildDropdown(String label, List<String> items, String value,
      ValueChanged<String?> onChanged) {
    return Container(
      color: const Color.fromARGB(103, 45, 45, 45),
      height: 50,
      width: 320,
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: Colors.black87,
        style: const TextStyle(color: Color.fromARGB(203, 255, 255, 255)),
        iconEnabledColor: Colors.white,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(59, 255, 255, 255)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: items.map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

