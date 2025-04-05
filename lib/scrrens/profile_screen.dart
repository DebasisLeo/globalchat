import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/scrrens/edit_screen.dart';
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
        title: Text(''),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             CircleAvatar(
  radius: 100,
  backgroundImage: NetworkImage(userProvider.userImageUrl), // Replace with the user's image URL from Firebase
),
              SizedBox(height: 10,),
            Text(userProvider.userName ),
             SizedBox(height: 10,),
             Text(userProvider.userEmail),
              SizedBox(height: 10,),
            Text(userProvider.userCountry ),
             SizedBox(height: 10,),
             ElevatedButton(onPressed: (){
              Navigator.pushReplacement(
        context,
        (MaterialPageRoute(builder: (context) {
          return EditScreen();
        })));
             }, child: Text('Edit Profile'))
           
          ],
        ),
      ),
    );
  }
}
