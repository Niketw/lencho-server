// lib/controllers/logout_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lencho/screens/auth/login_page.dart'; // Adjust the import to your LoginPage path.
import 'package:hive/hive.dart'; // Import Hive

class LogoutController extends GetxController {
  static LogoutController get instance => Get.find();

  /// Signs out the current user, destroys the session, and navigates to the login page.
  Future<void> logout() async {
    try {
      // Only attempt sign out if a user is currently signed in.
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      
      // Open the session box and clear all session data.
      final sessionBox = await Hive.openBox('sessionBox');
      await sessionBox.clear();

      // Optionally, you can also close the box.
      await sessionBox.close();

      // Navigate to the LoginPage.
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
