// widgets/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lencho/screens/auth/Login_Page.dart';
import 'package:lencho/screens/home/home_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the connection is active
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          // If no user is logged in, display the LoginPage.
          if (user == null) {
            return const LoginPage();
          } else {
            // If the user is logged in, display the HomePage.
            return const HomePage();
          }
        }
        // While waiting for authentication state, show a loading indicator.
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
