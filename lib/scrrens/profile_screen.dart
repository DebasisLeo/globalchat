import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var db = FirebaseFirestore.instance;
  var userID = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic>? userData = {};
  Future<void> getData() async {
    await db.collection('users').doc(userID).get().then((dataSnap) {
      setState(() {
        userData = dataSnap.data();
      });
    });
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Text(userData?['name'] ?? ''),
          Text(userData?['country'] ?? ''),
          Text(userData?['email'] ?? ''),
        ],
      ),
    );
  }
}
