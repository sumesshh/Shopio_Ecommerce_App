import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductProvider with ChangeNotifier {
  List<XFile>? pickedImages;
  bool isLoading = false;

  Stream<QuerySnapshot> getProductsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Pick images
  Future<void> pickImages() async {
    final images = await ImagePicker().pickMultiImage();
    if (images.isNotEmpty) {
      pickedImages = images;
      notifyListeners();
    }
  }

  // Upload images
  Future<List<String>> uploadImages() async {
    List<String> imageUrls = [];

    for (var image in pickedImages!) {
      File file = File(image.path);

      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + image.name;

      final ref = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child(fileName);

      await ref.putFile(file);
      String url = await ref.getDownloadURL();

      imageUrls.add(url);
    }

    return imageUrls;
  }

  // Upload product
  Future<void> uploadProduct({
    required String name,
    required String price,
    required String description,
    required String category,
    required BuildContext context,
  }) async {
    if (pickedImages == null || pickedImages!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select images")));
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      List<String> imageUrls = await uploadImages();

      await FirebaseFirestore.instance.collection('products').add({
        'name': name.trim(),
        'price': double.parse(price.trim()),
        'description': description.trim(),
        'category': category,
        'imageUrls': imageUrls,
        'createdBy': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': Timestamp.now(),
      });

      pickedImages = null;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product Uploaded")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    isLoading = false;
    notifyListeners();
  }

  // Get categories
  Stream<QuerySnapshot> getCategories() {
    return FirebaseFirestore.instance
        .collection('categories')
        .orderBy('isLast')
        .orderBy('name')
        .snapshots();
  }
}
