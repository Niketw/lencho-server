// lib/controllers/logout_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lencho/screens/auth/login_page.dart'; // Adjust the import to your LoginPage path.

class LogoutController extends GetxController {
  static LogoutController get instance => Get.find();

  /// Signs out the current user and navigates to the login page.
  Future<void> logout() async {
    try {
      // Only attempt sign out if a user is currently signed in.
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      // Navigate to the LoginPage. You can also use a named route like:
      // Get.offAllNamed('/login');
      Get.offAll(() => const LoginPage());
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific sign out errors.
      Get.snackbar(
        'Logout Error',
        e.message ?? 'An error occurred during logout.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Handle any other type of error.
      Get.snackbar(
        'Error',
        'Logout failed. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
