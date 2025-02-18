import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/scrrens/dashboard_screen.dart';
import 'package:globalchat/scrrens/splash_screen.dart';

class SignInController{
 static Future<void >loginAccount({required BuildContext context,required String email,required String pass})async{
  try {
     await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
     

     Navigator.pushAndRemoveUntil(context, (MaterialPageRoute(builder: (context){
return SplashScrren();
    })),(Route){
return false;
    });
     print('account created');
  } catch (e) {
   SnackBar message=SnackBar(backgroundColor: Colors.cyanAccent,  content: Text(e.toString()));
   ScaffoldMessenger.of(context).showSnackBar(message);
  }
  }
}