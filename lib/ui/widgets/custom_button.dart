import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final onPressed;
  final isLoading;
  final title;
  const CustomButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width, 44)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Text(title),
    );
  }
}
