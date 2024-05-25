import 'package:flutter/material.dart';

import '../Styles/app_style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final Widget suffixIcon;
  final String label;
  final String hint;
  final Color color;

  const CustomTextField(
      {super.key,
      required this.controller,
      required this.obscureText,
      required this.suffixIcon,
      required this.label,
      required this.hint,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: color,
      obscureText: obscureText,
      validator: (value) => value!.isEmpty ? 'required' : null,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: TextStyle(color: color),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 2),
              borderRadius: BorderRadius.circular(8)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: color),
              borderRadius: BorderRadius.circular(8)),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54)),
    );
  }
}
