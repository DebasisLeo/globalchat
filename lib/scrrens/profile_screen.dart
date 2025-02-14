import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var db = FirebaseFirestore.instance;
  var userID = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic>? userData = {};
  
 

  @override
  Widget build(BuildContext context) {

    var userProvider=Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Text(userProvider.userName ),
          Text(userProvider.userCountry ),
          Text(userProvider.userEmail),
        ],
      ),
    );
  }
}
