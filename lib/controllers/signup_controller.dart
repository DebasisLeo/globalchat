import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/scrrens/dashboard_screen.dart';

class SignUpController {
  static Future<void> createAccount(
      {required BuildContext context,
      required String email,
      required String pass,
      required String name,
      required String country}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);


var userID=FirebaseAuth.instance.currentUser!.uid;

var db=FirebaseFirestore.instance;
Map<String,dynamic>data={
  "name":name,
  "country":country,
  "email":email,
  "ID":userID.toString(),
  "createdAt": FieldValue.serverTimestamp(), 
};

try {
  await db.collection('users').doc(userID.toString()).set(data);
} catch (e) {
  print(e);
}
      Navigator.pushAndRemoveUntil(
          context,
          (MaterialPageRoute(builder: (context) {
            return Dashboard();
          })), (Route) {
        return false;
      });
      print('account created');
    } catch (e) {
      SnackBar message = SnackBar(
          backgroundColor: Colors.cyanAccent, content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(message);
    }
  }
}
