import 'package:flutter/material.dart';
import 'package:flighteasy/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Authentication")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            User? user = await _authService.signInWithGoogle();
            if (user != null) {
              print("Google Sign-In successful: ${user.email}");
              // Navigate to the next screen or display success message
            } else {
              print("Google Sign-In canceled or failed");
            }
          },
          icon: Icon(Icons.login),
          label: Text("Sign in with Google"),
        ),
      ),
    );
  }
}
