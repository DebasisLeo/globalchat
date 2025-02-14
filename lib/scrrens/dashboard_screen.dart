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
  List<String>chatIds=[];

  Future<void> getChatListData() async {
  await  db.collection('chatrooms').get().then((dataSnap) {
      for (var singleData in dataSnap.docs) {
        chatList.add(singleData.data());
        chatIds.add(singleData.id.toString());
      }
      setState(() {});
    });
  }
  @override
  void initState() {
    getChatListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider=Provider.of<UserProvider>(context);
    var scaffoldKey=GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
        appBar: AppBar(
          title: Text('Dashboard'),
          leading: InkWell(
            onTap: (){
              scaffoldKey.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                child: Text(userProvider.userName[0]),
              ),
            ),
          ),
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
                  leading: CircleAvatar(
                    child: Text(userProvider.userName[0]),
                  ),
                  title: Text(userProvider.userName,style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(userProvider.userEmail),
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
                  onTap: () async{
                  await  FirebaseAuth.instance.signOut();
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
        body: ListView.builder(
            itemCount: chatList.length,
            itemBuilder: (BuildContext context, int index) {
              var chatroomName=chatList[index]['chatroom_name']??'';
              return ListTile(
                onTap: () {
                   Navigator.push(
                        context,
                        (MaterialPageRoute(builder: (context) {
                          return ChatroomScreen(
                            chatroomName:chatroomName ,
                            chatroomId: chatIds[index],
                          );
                        })),);
                },
                leading: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  child: Text(chatroomName[0]),
                ),
                title: Text(chatroomName,style: TextStyle(color: Colors.white),),
                subtitle: Text(chatList[index]['des']),
              );
            }));
  }
}
