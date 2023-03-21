import 'package:flutter/material.dart';

class GoogleSignInWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const GoogleSignInWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
        fixedSize: MaterialStateProperty.all(
            Size(MediaQuery.of(context).size.width, 44)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              'assets/images/google_icon.png',
              scale: 2,
            ),
          ),
          Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
      ),
    );
  }
}
