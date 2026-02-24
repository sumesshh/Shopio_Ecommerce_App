import 'package:flutter/material.dart';

class GlossyNavButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const GlossyNavButton({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),

          // glossy effect only when active
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    Colors.lightBlueAccent.withOpacity(0.45),
                    Colors.white.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,

          border: isActive
              ? Border.all(color: Colors.lightBlueAccent.withOpacity(0.5))
              : null,

          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.lightBlueAccent.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),

        child: Icon(
          icon,
          size: 26,
          color: isActive ? Colors.blueAccent : Colors.grey.shade500,
        ),
      ),
    );
  }
}
