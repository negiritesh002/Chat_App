import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.focusNode
});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      decoration : InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xFF9E9E9E))
      )
    );
  }
}
