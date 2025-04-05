import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/scrrens/splash_screen.dart';

class SignUpController {
  static Future<void> createAccount({
    required BuildContext context,
    required String email,
    required String pass,
    required String name,
    required String country,
    required String imageUrl,
  }) async {
    try {
      // Create user account
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      String userID = FirebaseAuth.instance.currentUser!.uid;

      Map<String, dynamic> data = {
        "name": name,
        "country": country,
        "email": email,
        "imageUrl": imageUrl,
        "ID": userID,
        "createdAt": FieldValue.serverTimestamp(),
      };

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userID)
            .set(data);
      } catch (e) {
        print("Firestore error: $e");
      }

      // Navigate to splash screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScrren()),
        (route) => false,
      );

      print('Account created');
    } catch (e) {
      SnackBar message = SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(message);
    }
  }

  /// 🔐 Send password reset email
  static Future<void> sendResetLink(
    BuildContext context,
    String email,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset link sent to $email'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}