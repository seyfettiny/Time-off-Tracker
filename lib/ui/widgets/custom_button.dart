import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String title;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? border;
  const CustomButton({
    super.key,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    required this.onPressed,
    required this.title,
    this.border,
  });

  const CustomButton.cancelStyle({
    super.key,
    this.backgroundColor = Colors.white,
    this.foregroundColor = const Color(0xff344054),
    this.border = const BorderSide(color: Color(0xffD0D5DD), width: 1),
    this.isLoading = false,
    required this.onPressed,
    required this.title,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(MediaQuery.of(context).size.width, 44),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: widget.border ?? BorderSide.none,
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
        ),
        foregroundColor: MaterialStateProperty.all(
          widget.foregroundColor ?? Colors.white,
        ),
        elevation: MaterialStateProperty.all(0),
      ),
      onPressed: widget.onPressed,
      child: widget.isLoading
          ? Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }
}
