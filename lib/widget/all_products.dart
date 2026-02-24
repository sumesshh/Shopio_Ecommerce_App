import 'package:flutter/material.dart';
import 'package:shopio/Pages/productdetailpage.dart';
import 'package:shopio/models/product_models.dart';

class ProductCards extends StatelessWidget {
  final Productmodels product;
  const ProductCards({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Productdetails()),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        child: Container(
          margin: EdgeInsets.only(left: 10),
          width: 90,
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(product.image, height: 100, fit: BoxFit.cover),
              const SizedBox(height: 6),

              Text(
                style: TextStyle(fontWeight: FontWeight.bold),
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                product.price,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
