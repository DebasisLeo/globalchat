import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/scrrens/dashboard_screen.dart';
import 'package:globalchat/scrrens/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScrren extends StatefulWidget {
  const SplashScrren({super.key});

  @override
  State<SplashScrren> createState() => _SplashScrrenState();
}

class _SplashScrrenState extends State<SplashScrren> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), checkLoginStatus);
  }

  void checkLoginStatus() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      openLogin();
    } else {
      await Provider.of<UserProvider>(context, listen: false).getUserDetails();
      openDashboard();
    }
  }

  void openDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Dashboard()),
    );
  }

  void openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }
}
