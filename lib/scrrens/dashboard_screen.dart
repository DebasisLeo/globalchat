import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:globalchat/scrrens/chatroom_screen.dart';
import 'package:globalchat/scrrens/profile_screen.dart';
import 'package:globalchat/scrrens/splash_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var user = FirebaseAuth.instance.currentUser;
  var db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> chatList = [];
  List<String> chatIds = [];

  Future<void> getChatListData() async {
    await db.collection('chatrooms').get().then((dataSnap) {
      for (var singleData in dataSnap.docs) {
        chatList.add(singleData.data());
        chatIds.add(singleData.id.toString());
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getChatListData();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Dashboard'),
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 100,
              backgroundImage: userProvider.userImageUrl.isNotEmpty
                  ? NetworkImage(userProvider.userImageUrl) // Use user's image
                  : null,
              child: userProvider.userImageUrl.isEmpty
                  ? Text(userProvider.userName[0]) // Fallback to the first letter of name
                  : null,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(height: 50), // Space for top of the drawer
            // User info section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: userProvider.userImageUrl.isNotEmpty
                        ? NetworkImage(userProvider.userImageUrl)
                        : null,
                    child: userProvider.userImageUrl.isEmpty
                        ? Text(userProvider.userName[0]) // Fallback to name's first letter
                        : null,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProvider.userName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(userProvider.userEmail),
                    ],
                  ),
                ],
              ),
            ),
            Divider(), // Divider to separate user info from other menu items
            // Profile Menu Item
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return Profile();
                  }),
                );
              },
              leading: Icon(Icons.public),
              title: Text("Profile"),
            ),
            SizedBox(height: 10),
            // Log Out Menu Item
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return SplashScrren();
                  }),
                  (Route) {
                    return false;
                  },
                );
              },
              leading: Icon(Icons.logout),
              title: Text("LogOut"),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: chatList.length,
        itemBuilder: (BuildContext context, int index) {
          var chatroomName = chatList[index]['chatroom_name'] ?? '';
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChatroomScreen(
                    chatroomName: chatroomName,
                    chatroomId: chatIds[index],
                  );
                }),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(chatroomName[0]),
            ),
            title: Text(
              chatroomName,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(chatList[index]['des']),
          );
        },
      ),
    );
  }
}
