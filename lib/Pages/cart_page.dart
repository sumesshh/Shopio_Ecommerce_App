import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),

      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        backgroundColor: Color(0xFFF2F2F2),
      ),

      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : ListView.builder(
              itemCount: cartProvider.cartItems.length,

              itemBuilder: (context, index) {
                final product = cartProvider.cartItems[index];

                return ListTile(
                  leading: Image.network(
                    product.mediaUrls[0],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),

                  title: Text(product.name),

                  subtitle: Text("₹${product.price}"),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cartProvider.removeFromCart(product);
                    },
                  ),
                );
              },
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),

        child: Text(
          "Total: ₹${cartProvider.totalPrice}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
