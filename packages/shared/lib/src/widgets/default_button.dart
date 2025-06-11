import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class DefaultButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const DefaultButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: super.key,
      onPressed: onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 60)),
        backgroundColor: WidgetStateProperty.resolveWith(
          submitButtonWidgetState,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        shadowColor: WidgetStateProperty.all(Colors.deepOrange),
        elevation: WidgetStateProperty.all(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
