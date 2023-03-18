import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String title;
  const CustomButton({
    super.key,
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
            Size(MediaQuery.of(context).size.width, 44)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: widget.onPressed,
      child: widget.isLoading
          ? Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Text(widget.title),
    );
  }
}
