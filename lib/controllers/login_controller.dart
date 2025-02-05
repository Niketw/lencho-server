// login_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/screens/auth/Email_verification_page.dart'; // Your email verification screen
import 'package:lencho/screens/home/home_page.dart'; // Your home page

class LoginController extends GetxController {
  // TextEditingControllers for the login form fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Dispose controllers when the controller is closed.
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Logs in the user with email and password, then checks email verification.
  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Basic validations.
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return;
    }

    try {
      // Attempt to sign in with Firebase.
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        // Check if the user's email is verified.
        if (user.emailVerified) {
          Get.snackbar('Success', 'Logged in successfully.');
          // Navigate to the home page.
          Get.offAll(() => HomePage());
        } else {
          // Email is not verified; sign out the user and navigate to the verification page.
          await FirebaseAuth.instance.signOut();
          Get.snackbar('Not Verified',
              'Please verify your email before logging in.');
          Get.to(() => EmailVerificationPage());
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Error', e.message ?? 'Unknown error');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
