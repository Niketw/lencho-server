// phone_verification_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import your next screen after verification, e.g. HomePage if available
// import 'package:your_app/screens/home_page.dart';

class PhoneVerificationController extends GetxController {
  // Controller for the phone number field.
  final phoneController = TextEditingController();
  // Controller for the OTP field.
  final otpController = TextEditingController();

  // Holds the verification ID returned by Firebase.
  String? _verificationId;

  /// Sends an OTP to the phone number entered.
  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number.');
      return;
    }

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval or instant verification.
          await FirebaseAuth.instance.signInWithCredential(credential);
          Get.snackbar('Success', 'Phone number verified automatically.');
          // Navigate to your next page. Replace HomePage() with your target page.
          // Get.offAll(() => HomePage());
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', e.message ?? 'Verification failed.');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          Get.snackbar('Info', 'OTP sent to your phone.');
          // Optionally, you could navigate to a separate OTP screen here.
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  /// Verifies the OTP entered by the user.
  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.isEmpty || _verificationId == null) {
      Get.snackbar('Error', 'Please enter the OTP.');
      return;
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.snackbar('Success', 'Phone number verified.');
      // After successful verification, navigate to your home page or next screen.
      // Get.offAll(() => HomePage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'OTP verification failed.');
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
