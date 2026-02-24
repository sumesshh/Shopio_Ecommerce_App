import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileProvider extends ChangeNotifier {
  String? _imageUrl;
  bool _isLoading = false;

  String? get imageUrl => _imageUrl;
  bool get isLoading => _isLoading;

  final ImagePicker _picker = ImagePicker();

  /// Loading profile image from Firestore
  Future<void> loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists && doc.data()!.containsKey('profileImage')) {
      _imageUrl = doc['profileImage'];
      notifyListeners();
    }
  }

  /// Picking  nd  Upload image
  Future<void> pickAndUploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    File file = File(pickedFile.path);

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      await ref.putFile(file);

      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'profileImage': imageUrl,
      }, SetOptions(merge: true));

      _imageUrl = imageUrl;
    } catch (e) {
      debugPrint("Upload error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
