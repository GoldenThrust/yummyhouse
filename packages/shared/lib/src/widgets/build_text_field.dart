import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool obscureText;
  final String? displayError;
  final ValueChanged onChanged;

  const AppTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.onChanged,
    this.displayError,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.deepOrange),
        labelText: label,
        filled: true,
        fillColor: Colors.blueGrey[50],
        errorText: displayError,
        errorBorder:
            displayError != null
                ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.deepOrange, // border color when focused
            width: 2.0, // border width when focused
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
