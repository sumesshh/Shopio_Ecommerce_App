import 'package:flutter/material.dart';
//button glass blue gradient  color reusable code

class ButtonColor extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final VoidCallback? onTap;
  final bool isFullWidth;

  const ButtonColor({
    super.key,
    this.icon,
    this.text,
    this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: isFullWidth ? double.infinity : 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 160, 234).withOpacity(0.45),
              Color.fromARGB(255, 170, 232, 252).withOpacity(0.7),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, color: Colors.white)
              : Text(
                  text ?? "",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 0, 123, 195),
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
