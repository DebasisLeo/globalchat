import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName='Joy';
  String userEmail='ok';
  String userId='1234';
  String userCountry='bd';


    var db = FirebaseFirestore.instance;
  var userID = FirebaseAuth.instance.currentUser!.uid;
  Future<void> getUserDetails() async {
    await db.collection('users').doc(userID).get().then((dataSnap) {
      userName=dataSnap.data()?['name'] ?? '';
       userEmail=dataSnap.data()?['email'] ?? '';
        userCountry=dataSnap.data()?['country'] ?? '';
         userId=dataSnap.data()?['ID'] ?? '';

         notifyListeners();
    });
  }







}