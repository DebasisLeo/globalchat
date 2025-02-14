import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/scrrens/profile_screen.dart';
import 'package:globalchat/scrrens/splash_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: Drawer(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    (MaterialPageRoute(builder: (context) {
                      return Profile();
                    })),
                  );
                },
                leading: Icon(Icons.public),
                title: Text("Profile"),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      (MaterialPageRoute(builder: (context) {
                        return SplashScrren();
                      })), (Route) {
                    return false;
                  });
                },
                leading: Icon(Icons.logout),
                title: Text("LogOut"),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Text('Welcome'),
          Text((user?.email ?? '').toString()),
        ],
      ),
    );
  }
}
