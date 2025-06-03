import 'package:flutter/material.dart';

Color? submitButtonWidgetState(Set<WidgetState> states) {
  if (states.contains(WidgetState.disabled)) {
    return Colors.deepOrangeAccent; // Disabled color
  }
  return Colors.deepOrange; // Enabled color
}