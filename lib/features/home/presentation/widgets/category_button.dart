import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onPressed;
  final String imagePath;

  const CategoryButton({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onPressed,
    this.imagePath = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(
              color: isSelected ? const Color(0xFF448AFF) : Colors.white54,
              width: 2.0,
            ),
          ),
        ),
      ),
      icon: imagePath.isNotEmpty
          ? Image.asset(
        imagePath,
        width: 36, // Adjust the width as needed
        height: 36, // Adjust the height as needed
      )
          : const SizedBox.shrink(), // Use SizedBox.shrink() if no imagePath
      label: Text(
        category,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
