import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  String? _imageUrl;
  String? _userName;
  bool _isLoading = false;

  String? get imageUrl => _imageUrl;
  String? get userName => _userName;
  bool get isLoading => _isLoading;

  /// ✅ LOAD PROFILE (used in ProfilePage initState)
  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _imageUrl = data['image'];
      _userName = data['name']; // ✅ load name also
      notifyListeners();
    }
  }

  /// ✅ UPDATE USER NAME
  Future<void> updateUserName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': name, // ✅ save name
      }, SetOptions(merge: true));

      _userName = name; // update UI
      notifyListeners();
    } catch (e) {
      debugPrint("Name update error: $e");
    }
  }

  /// ✅ IMAGE UPLOAD
  Future<void> pickAndUploadImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      File file = File(pickedFile.path);

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      await ref.putFile(file);

      final downloadUrl = await ref.getDownloadURL();

      // ✅ SAVE IMAGE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'image': downloadUrl,
      }, SetOptions(merge: true));

      _imageUrl = downloadUrl;
    } catch (e) {
      debugPrint("Upload error: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}