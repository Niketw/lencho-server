// phone_verification_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneVerificationController extends GetxController {
  // Controller for the phone number field.
  final phoneController = TextEditingController();
  // Controller for the OTP field.
  final otpController = TextEditingController();

  // Holds the verification ID from Firebase.
  String? _verificationId;

  /// Sends an OTP to the phone number entered.
  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      Get.snackbar('Error', 'Please enter your phone number.');
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification.
        await FirebaseAuth.instance.signInWithCredential(credential);
        Get.snackbar('Success', 'Phone number verified automatically.');
        // TODO: Navigate to your home page or next step.
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', e.message ?? 'Verification failed.');
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        Get.snackbar('Info', 'OTP sent to your phone.');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
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
      // TODO: Navigate to your home page or next step.
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
