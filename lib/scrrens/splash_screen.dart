import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:globalchat/scrrens/login_screen.dart';

class SplashScrren extends StatefulWidget {
  const SplashScrren({super.key});

  @override
  State<SplashScrren> createState() => _SplashScrrenState();
}

class _SplashScrrenState extends State<SplashScrren> {
  @override
  var user = FirebaseAuth.instance.currentUser;
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      if (user == null) {
        openLogin();
      }
      else{
        openDashboard();
      }
    });
  }

  void openDashboard() {
    Navigator.pushReplacement(
        context,
        (MaterialPageRoute(builder: (context) {
          return Login();
        })));
  }

  void openLogin() {
    Navigator.pushReplacement(
        context,
        (MaterialPageRoute(builder: (context) {
          return Login();
        })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('splash scrren')),
    );
  }
}
