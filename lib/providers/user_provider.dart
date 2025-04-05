import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = 'Joy';
  String userEmail = 'ok';
  String userId = '1234';
  String userCountry = 'bd';
  String userImageUrl = '';

  var db = FirebaseFirestore.instance;

  Future<void> getUserDetails() async {
    var userID = FirebaseAuth.instance.currentUser!.uid;

    var docSnap = await db.collection('users').doc(userID).get();

    if (!docSnap.exists || docSnap.data() == null) {
      print("No user data found for ID: $userID");
      return;
    }

    var data = docSnap.data()!;
    userName = data['name'] ?? '';
    userEmail = data['email'] ?? '';
    userCountry = data['country'] ?? '';
    userId = data['ID'] ?? '';
    userImageUrl = data['imageUrl'] ?? '';

    notifyListeners();
  }
}
