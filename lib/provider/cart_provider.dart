import 'package:flutter/material.dart';
import '../models/product_models.dart';

class CartProvider with ChangeNotifier {
  final List<Productmodels> _cartItems = [];

  List<Productmodels> get cartItems => _cartItems;

  void addToCart(Productmodels product) {
    _cartItems.add(product);
    notifyListeners();
  }

  void removeFromCart(Productmodels product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price;
    }
    return total;
  }
}
