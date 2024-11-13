import 'package:flutter/material.dart';

Widget buildTextField(String label, TextEditingController controller) {
  return Container(
    color: const Color.fromARGB(103, 45, 45, 45),
    height: 50,
    width: 320,
    child: TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(
          color: Color.fromARGB(207, 255, 255, 255),
          fontFamily: 'Poppins',
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(59, 255, 255, 255)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),
  );
}
