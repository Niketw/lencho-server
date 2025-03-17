import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CampaignController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Posts a new campaign after verifying the current user is authorized.
  Future<void> postCampaign(String title, String description) async {
    // Get the current Firebase user.
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    // Check if the user's email is in the authUser collection.
    final authUserQuery = await _db
        .collection('authUser')
        .where('email', isEqualTo: user.email)
        .get();

    if (authUserQuery.docs.isEmpty) {
      Get.snackbar('Access Denied', 'You are not authorized to post campaigns.');
      return;
    }

    // Create the campaign data.
    final campaignData = {
      'title': title,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
      'postedBy': user.email,
      'userId': user.uid,
    };

    try {
      // Save the campaign to the campaigns collection.
      await _db.collection('campaigns').add(campaignData);
      Get.snackbar('Success', 'Campaign posted successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to post campaign: $e');
    }
  }
}
