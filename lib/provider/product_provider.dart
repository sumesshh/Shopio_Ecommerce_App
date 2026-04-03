import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductProvider with ChangeNotifier {
  List<XFile>? pickedImages;
  XFile? pickedVideo;
  bool isLoading = false;

  // ================= GET PRODUCTS =================
  Stream<QuerySnapshot> getProductsByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          // 🔥 DEBUG PRINT
          for (var doc in snapshot.docs) {
            print("PRODUCT DATA: ${doc.data()}");
          }
          return snapshot;
        });
  }

  // ================= PICK VIDEO =================
  Future<void> pickVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      pickedVideo = video;
      notifyListeners();
    }
  }

  // ================= PICK IMAGES =================
  Future<void> pickImages() async {
    final images = await ImagePicker().pickMultiImage();

    if (images.isNotEmpty) {
      pickedImages = images;
      notifyListeners();
    }
  }

  // ================= UPLOAD MEDIA =================
  Future<List<Map<String, dynamic>>> uploadMedia() async {
    List<Map<String, dynamic>> mediaList = [];

    try {
      //  Upload images
      if (pickedImages != null && pickedImages!.isNotEmpty) {
        for (var image in pickedImages!) {
          File file = File(image.path);

          String fileName =
              "${DateTime.now().millisecondsSinceEpoch}_${image.name}";

          final ref = FirebaseStorage.instance.ref().child(
            'product_images/$fileName',
          );

          await ref.putFile(file);
          String url = await ref.getDownloadURL();

          mediaList.add({"url": url, "type": "image"});
        }
      }

      //  Upload video
      if (pickedVideo != null) {
        File file = File(pickedVideo!.path);

        String fileName = "${DateTime.now().millisecondsSinceEpoch}.mp4";

        final ref = FirebaseStorage.instance.ref().child(
          'product_videos/$fileName',
        );

        await ref.putFile(file);
        String url = await ref.getDownloadURL();

        mediaList.add({"url": url, "type": "video"});
      }
    } catch (e) {
      print("UPLOAD ERROR: $e");
    }

    print("FINAL MEDIA: $mediaList");

    return mediaList;
  }

  // ================= UPLOAD PRODUCT =================
  Future<void> uploadProduct({
    required String name,
    required String price,
    required String description,
    required String category,
    required BuildContext context,
  }) async {
    //  VALIDATION
    if ((pickedImages == null || pickedImages!.isEmpty) &&
        pickedVideo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select media")));
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      // 🔥 DEBUG PRINT
      print("RAW PRICE INPUT: $price");
      print("PARSED PRICE: ${double.tryParse(price.trim())}");

      //  Upload media
      List<Map<String, dynamic>> media = await uploadMedia();

      //  BLOCK EMPTY MEDIA
      if (media.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Media upload failed")));
        isLoading = false;
        notifyListeners();
        return;
      }

      //  SAVE TO FIRESTORE
      await FirebaseFirestore.instance.collection('products').add({
        'name': name.trim(),
        'price': double.tryParse(price.trim()) ?? 0,
        'description': description.trim(),
        'category': category,
        'media': media,
        'createdBy': FirebaseAuth.instance.currentUser?.uid ?? "",
        'createdAt': Timestamp.now(),
      });

      //  RESET
      pickedImages = null;
      pickedVideo = null;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product Uploaded")));
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    isLoading = false;
    notifyListeners();
  }

  // ================= GET CATEGORIES =================
  Stream<QuerySnapshot> getCategories() {
    return FirebaseFirestore.instance
        .collection('categories')
        .orderBy('isLast')
        .orderBy('name')
        .snapshots();
  }

  // ================= UPDATE PRODUCT =================
  Future<void> updateProduct({
    required String productId,
    required String name,
    required String price,
    required String description,
    required String category,
    bool updateMedia = false,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // 🔥 DEBUG PRINT
      print("RAW UPDATE PRICE: $price");
      print("PARSED UPDATE PRICE: ${double.tryParse(price.trim())}");

      List<Map<String, dynamic>> media = [];

      //  Only upload new media if user selected
      if (updateMedia) {
        media = await uploadMedia();

        if (media.isEmpty) {
          isLoading = false;
          notifyListeners();
          return;
        }
      }

      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({
            'name': name.trim(),
            'price': double.tryParse(price.trim()) ?? 0,
            'description': description.trim(),
            'category': category,
            if (updateMedia) 'media': media,
          });

      //  Reset picked files
      pickedImages = null;
      pickedVideo = null;
    } catch (e) {
      print("UPDATE ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
