import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lencho/models/campaign.dart';

class CampaignController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Posts a new campaign with the given details.
  Future<void> postCampaign({
    required String title,
    required String organisation,
    required String location,
    required String details,
  }) async {
    final campaignData = {
      'title': title,
      'organisation': organisation,
      'location': location,
      'details': details,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await _db.collection('campaigns').add(campaignData);
      Get.snackbar('Success', 'Campaign posted successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to post campaign: $e');
    }
  }

  /// Streams the list of campaigns ordered by the most recent.
  Stream<List<Campaign>> streamCampaigns() {
    return _db
        .collection('campaigns')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Campaign.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}
