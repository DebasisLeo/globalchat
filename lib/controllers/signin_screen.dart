import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/scrrens/splash_screen.dart';

class SignInController {
  static Future<void> loginAccount({
    required BuildContext context,
    required String email,
    required String pass,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: pass);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScrren()),
        (route) => false,
      );

      print('Logged in successfully');
    } catch (e) {
      SnackBar message = SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(message);
    }
  }
}
