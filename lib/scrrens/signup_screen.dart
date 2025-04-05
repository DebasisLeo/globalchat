import 'package:flutter/material.dart';
import 'package:globalchat/controllers/signup_controller.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;

  final userForm = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController imageUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(height: 30),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Form(
                      key: userForm,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: email,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.deepPurple),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: pass,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              }
                              final passRegex = RegExp(
                                  r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$');
                              if (!passRegex.hasMatch(value)) {
                                return "Password must be at least 6 characters and include letters and numbers";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon:
                                  Icon(Icons.lock, color: Colors.deepPurple),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: name,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.deepPurple),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: country,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Country is required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon:
                                  Icon(Icons.public, color: Colors.deepPurple),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
                            controller: imageUrl,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Image URL is required";
                              }
                              final uri = Uri.tryParse(value);
                              if (uri == null || !uri.isAbsolute) {
                                return "Enter a valid image URL";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Profile Image URL',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              prefixIcon:
                                  Icon(Icons.image, color: Colors.deepPurple),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 100),
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () async {
                              isLoading = true;
                              setState(() {});
                              if (userForm.currentState!.validate()) {
                                await SignUpController.createAccount(
                                  context: context,
                                  email: email.text,
                                  pass: pass.text,
                                  name: name.text,
                                  country: country.text,
                                  imageUrl: imageUrl.text,
                                );
                              }
                              isLoading = false;
                              setState(() {});
                            },
                            child: isLoading
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Create An Account',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
