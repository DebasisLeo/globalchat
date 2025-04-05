import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatroomName;
  final String chatroomId;

  const ChatroomScreen({
    super.key,
    required this.chatroomName,
    required this.chatroomId,
  });

  @override
  State<ChatroomScreen> createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  final TextEditingController messageText = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
 

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection != ScrollDirection.idle) {
        _isUserScrolling = true;
      }
    });

    // Ensure user details are loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).getUserDetails();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messageText.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (messageText.text.isEmpty) return;

    Map<String, dynamic> messageData = {
      'text': messageText.text,
      'sender': Provider.of<UserProvider>(context, listen: false).userName,
      'sender_id': Provider.of<UserProvider>(context, listen: false).userId,
      'sender_image_url': Provider.of<UserProvider>(context, listen: false).userImageUrl,
      'chatroom_id': widget.chatroomId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await db.collection('messages').add(messageData);
      messageText.clear();
      _scrollToBottom();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  void _scrollToBottom() {
    if (!_isUserScrolling) {
      Future.delayed(Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.minScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Widget singleItem({
    required String senderName,
    required String text,
    required String senderID,
    required String senderImageUrl, // Added for image URL
  }) {
    bool isCurrentUser =
        senderID == Provider.of<UserProvider>(context, listen: false).userId;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender's Profile Image and Name
          Row(
            mainAxisAlignment:
                isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              // Profile Image (fallback to initials if no image URL)
              CircleAvatar(
                radius: 18, // Adjusted size for profile image
                backgroundImage: senderImageUrl.isNotEmpty
                    ? NetworkImage(senderImageUrl)
                    : null, // Fallback image URL if empty
                child: senderImageUrl.isEmpty
                    ? Text(senderName[0].toUpperCase()) // Fallback to the first letter of name
                    : null,
              ),
              SizedBox(width: 8),
              // Sender Name
              Padding(
                padding: EdgeInsets.only(bottom: 2.0),
                child: Text(
                  senderName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          // Message Bubble
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: isCurrentUser ? Radius.circular(14) : Radius.zero,
                bottomRight: isCurrentUser ? Radius.zero : Radius.circular(14),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isCurrentUser ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatroomName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db
                  .collection('messages')
                  .where('chatroom_id', isEqualTo: widget.chatroomId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Some error has occurred'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                var allMessages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: allMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var senderImageUrl = allMessages[index].data().containsKey('sender_image_url')
                        ? allMessages[index]['sender_image_url']
                        : ''; // Empty string if not found
                    return singleItem(
                      senderName: allMessages[index]['sender'],
                      text: allMessages[index]['text'],
                      senderID: allMessages[index]['sender_id'],
                      senderImageUrl: senderImageUrl, // Fetch image URL from the message
                    );
                  },
                );
              },
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageText,
                    onTap: _scrollToBottom,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Write a message...',
                      hintStyle: TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
