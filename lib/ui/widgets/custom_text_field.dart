import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final ValueNotifier<bool> obscureTextNotifier;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.obscureTextNotifier,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureTextNotifier,
      builder: (context, isObscured, child) {
        return TextField(
          controller: controller,
          obscureText: isPassword && isObscured,
          onChanged: (value) {
            obscureTextNotifier.value = value.isNotEmpty;
          },
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            border: const OutlineInputBorder(),
            suffixIcon: isPassword && controller.text.isNotEmpty
                ? IconButton(
              icon: Icon(isObscured
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                obscureTextNotifier.value = !isObscured;
              },
            )
                : controller.text.isNotEmpty
                ? IconButton(
              onPressed: () {
                controller.clear();
                obscureTextNotifier.value = controller.text.isNotEmpty;
              },
              icon: Icon(Icons.clear),
            )
                : null,
          ),
        );
      },
    );
  }
}
