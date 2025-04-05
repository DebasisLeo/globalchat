import 'package:flutter/material.dart';
import 'package:globalchat/controllers/signup_controller.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController resetEmail = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Reset Password"),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: resetEmail,
          decoration: InputDecoration(
            labelText: "Enter your email",
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Email is required";
            }
            final emailRegex =
                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) {
              return "Enter a valid email";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              setState(() {
                isSending = true;
              });

              try {
                // Pass context and email to the sendResetLink method
                await SignUpController.sendResetLink(
                  context, // Pass the context
                  resetEmail.text, // Pass the email
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Reset link sent to your email"),
                ));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Error: ${e.toString()}"),
                ));
              }

              setState(() {
                isSending = false;
              });
            }
          },
          child: isSending
              ? CircularProgressIndicator(color: Colors.white)
              : Text("Send Link"),
        ),
      ],
    );
  }
}
