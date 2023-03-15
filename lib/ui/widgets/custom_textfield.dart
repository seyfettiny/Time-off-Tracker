import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String title;
  final BoxConstraints constraints;
  final TextEditingController controller;
  final bool obscureText;
  const CustomTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.constraints = const BoxConstraints(
      minHeight: 44,
      maxHeight: 44,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(title),
            ),
          ),
          TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            autofocus: false,
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              constraints: constraints,
              hintText: hintText,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}
