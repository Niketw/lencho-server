import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthUserController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Observable that tracks if the user is authorized.
  RxBool isAuthorized = false.obs;
  
  /// Checks if the current user is in the 'authUser' collection.
  Future<void> checkAuthorization() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      isAuthorized.value = false;
      print("No user logged in.");
      return;
    }
    print("Checking authorization for user: ${user.email}");
    final snapshot = await _db
        .collection('authUser')
        .where('email', isEqualTo: user.email)
        .get();
    print("Found ${snapshot.docs.length} authUser documents.");
    isAuthorized.value = snapshot.docs.isNotEmpty;
  }
  
  @override
  void onInit() {
    super.onInit();
    checkAuthorization();
  }
  
  @override
  void onReady() {
    super.onReady();
    // Listen to auth state changes to update the authorization status for each user.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      checkAuthorization();
    });
  }
}
