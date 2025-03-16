import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:lencho/screens/auth/Email_verification_page.dart';
import 'package:lencho/screens/home/home_page.dart';

class LoginController extends GetxController {
  // TextEditingControllers for the login form fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Hive box for session data.
  late Box sessionBox;

  @override
  void onInit() {
    super.onInit();
    // Initialize Hive box for session.
    initHive();
  }

  Future<void> initHive() async {
    sessionBox = await Hive.openBox('sessionBox');
  }

  // Dispose controllers and close the Hive box when the controller is closed.
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    sessionBox.close();
    super.onClose();
  }

  /// Logs in the user with email and password, then checks email verification.
  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return;
    }
    
    try {
      print("Attempting to sign in...");
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      print("User signed in: ${user?.email}");
    
      if (user != null) {
        if (user.emailVerified) {
          // Save session details in Hive
          sessionBox.put('loggedIn', true);
          sessionBox.put('userEmail', user.email);
          
          print("Email verified. Navigating to HomePage.");
          Get.snackbar('Success', 'Logged in successfully.');
          Get.offAll(() => HomePage());
        } else {
          print("Email not verified. Navigating to EmailVerificationPage.");
          Get.snackbar('Not Verified', 'Please verify your email before logging in.');
          Get.to(() => EmailVerificationPage());
        }
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      Get.snackbar('Login Error', e.message ?? 'Unknown error');
    } catch (e) {
      print("Other error: $e");
      Get.snackbar('Error', e.toString());
    }
  }
}
