import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // TextEditingControllers for each form field.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileController = TextEditingController();

  // Dispose controllers when the controller is closed.
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    super.onClose();
  }

  /// Example method to send OTP or create a user account.
  Future<void> sendOtp() async {
    // Retrieve values from the controllers.
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final mobile = mobileController.text.trim();

    // Basic validations (customize as needed)
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        mobile.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.');
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar('Error', 'Passwords do not match.');
      return;
    }

    // Here you can add logic to send OTP to the mobile or email.

    // Example Firebase Authentication sign up (for email/password):
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // You may want to update the user's display name, etc.
      userCredential.user?.updateDisplayName(name);
      Get.snackbar('Success', 'User registered successfully.');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Error', e.message ?? 'Unknown error');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
