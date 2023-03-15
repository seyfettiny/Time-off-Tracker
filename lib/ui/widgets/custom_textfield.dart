import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String title;
  final BoxConstraints constraints;
  final TextEditingController controller;
  final validator;
  final bool obscureText;
  const CustomTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    this.constraints = const BoxConstraints(
      minHeight: 44,
      maxHeight: 64,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(title),
          ),
          SizedBox(
            height: 64,
            child: TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              autofocus: false,
              obscureText: obscureText,
              controller: controller,
              validator: validator,
              decoration: InputDecoration(
                counterText: ' ',
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
          ),
        ],
      ),
    );
  }
}
