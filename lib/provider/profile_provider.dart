// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ProfileProvider extends ChangeNotifier {
//   String? _imageUrl;
//   bool _isLoading = false;

//   String? get imageUrl => _imageUrl;
//   bool get isLoading => _isLoading;

//   final ImagePicker _picker = ImagePicker();

//   /// Loading profile image from Firestore
//   Future<void> loadProfileImage() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     if (doc.exists && doc.data()!.containsKey('profileImage')) {
//       _imageUrl = doc['profileImage'];
//       notifyListeners();
//     }
//   }

//   /// Picking  nd  Upload image
//   Future<void> pickAndUploadImage() async {

//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedFile == null) return;

//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     _isLoading = true;
//     notifyListeners();

//     File file = File(pickedFile.path);

//     try {
//       final ref = FirebaseStorage.instance
//           .ref()
//           .child('profile_images')
//           .child('${user.uid}.jpg');

//       await ref.putFile(file);

//       final imageUrl = await ref.getDownloadURL();

//       await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//         'profileImage': imageUrl,
//       }, SetOptions(merge: true));

//       _imageUrl = imageUrl;
//     } catch (e) {
//       debugPrint("Upload error: $e");
//     }

//     _isLoading = false;
//     notifyListeners();
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileProvider extends ChangeNotifier {
  String? _imageUrl;
  String? _userName;
  bool _isLoading = false;

  String? get imageUrl => _imageUrl;
  String? get userName => _userName;
  bool get isLoading => _isLoading;

  final ImagePicker _picker = ImagePicker();

  /// Load profile data
  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        _imageUrl = data?['profileImage'];
        _userName = data?['name'];
      }
    } catch (e) {
      debugPrint("Load profile error: $e");
    }

    notifyListeners();
  }

  /// Update user name
  Future<void> updateUserName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'name': name},
      );

      _userName = name;
      notifyListeners();
    } catch (e) {
      debugPrint("Update name error: $e");
    }
  }

  /// Pick & upload profile image
  Future<void> pickAndUploadImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

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
