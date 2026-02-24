import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isloading = false;
  bool get isloading => _isloading;

  User? get user => _auth.currentUser;
  //register page
  Future<String?> signUp(String email, String password, String name) async {
    _isloading = true;
    // ChangeNotifier();
    notifyListeners();
    try {
      UserCredential userdata = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //we need to collect login data from user to  store and set them as a default user
      await _firestore.collection('users').doc(userdata.user!.uid).set({
        'uid': userdata.user!.uid,
        'name': name,
        'email': email,
        'role': 'user',
        'createdAt': DateTime.now(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email already in use";
      } else if (e.code == 'weak-password') {
        return "Password is too weak";
      } else if (e.code == 'invalid-email') {
        return "Invalid email format";
      } else {
        return "Something went wrong";
      }
    } catch (e) {
      print("FULL ERROR: $e");
      return e.toString();
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }

  //login page
  Future<String?> login(String email, String password) async {
    _isloading = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
