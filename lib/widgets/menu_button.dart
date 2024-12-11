import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const MenuButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
