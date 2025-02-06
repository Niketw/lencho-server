// register_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lencho/screens/auth/Email_Verification_Page.dart'; // Email verification screen
import 'package:lencho/screens/auth/Phone_Verification_Page.dart'; // Phone verification screen

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

  /// Registers the user and sends an email verification link.
  Future<void> sendOtp() async {
    // Retrieve values from the controllers.
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final mobile = mobileController.text.trim();

    // Basic validations.
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

    try {
      // Create the user using email and password.
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update display name.
      await userCredential.user?.updateDisplayName(name);

      // Send the verification email.
      await userCredential.user?.sendEmailVerification();

      Get.snackbar('Verification Email Sent',
          'A verification link has been sent to $email. Please check your inbox.');

      // Navigate to the email verification screen.
      Get.to(() => EmailVerificationPage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Registration Error', e.message ?? 'Unknown error');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Registers the user using phone number verification.
  Future<void> sendPhoneOtp() async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();

    if (name.isEmpty || mobile.isEmpty) {
      Get.snackbar('Error', 'Please fill in your name and mobile number.');
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // This callback is executed when verification is done automatically.
          // Optionally, you can sign in with the credential here if needed.
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Phone Verification Error', e.message ?? 'Unknown error');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Navigate to the phone verification screen and pass the verificationId.
          Get.to(() => PhoneVerificationPage(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout callback.
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
