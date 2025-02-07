import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  /// Sends a verification email to the current user.
  Future<void> sendVerificationEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        Get.snackbar('Verification Email Sent',
            'A verification link has been sent to your email. Please check your inbox.');
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    } else {
      Get.snackbar('Info', 'Your email is already verified.');
    }
  }
  
  /// Optionally, you can add a method to check verification manually.
  Future<bool> checkEmailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      user = FirebaseAuth.instance.currentUser;
      return user?.emailVerified ?? false;
    }
    return false;
  }
}
