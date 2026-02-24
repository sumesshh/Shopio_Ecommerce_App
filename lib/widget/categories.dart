import 'package:flutter/material.dart';

class Category_Tile extends StatelessWidget {
  final String images;
  const Category_Tile({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(10),
      child: Container(
        margin: EdgeInsets.all(10),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusGeometry.circular(10),
        ),
        child: Image.asset(images),
      ),
    );
  }
}
