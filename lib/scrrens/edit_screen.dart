import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var editName = GlobalKey<FormState>();
  TextEditingController NameText = TextEditingController();

  var db=FirebaseFirestore.instance;
  



 Future <void> updateName()async{
    Map<String,dynamic>dataToUpdate={
    "name":NameText.text
  };

 await db.collection('users').doc(Provider.of<UserProvider>(context, listen: false).userId).update(dataToUpdate);
Provider.of<UserProvider>(context, listen: false).getUserDetails();
 Navigator.pop(context);
  }

  @override
  void initState() {
    NameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          InkWell(
            onTap: () {
              if (editName.currentState!.validate()) {
                updateName();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
      body: Form(
        key: editName,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: NameText,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name IS Required';
                  }
                  return null;
                },
                decoration: InputDecoration(label: Text('Name')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
