import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  // Controllers for each extra detail.
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalZipController = TextEditingController();
  final locationController = TextEditingController(); // For manual location input
  
  /// Submits the details to Firestore for the current user.
  Future<void> submitDetails() async {
    final streetAddress = streetAddressController.text.trim();
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final postalZip = postalZipController.text.trim();
    final locationText = locationController.text.trim(); // Expect "latitude, longitude"

    if (streetAddress.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        postalZip.isEmpty ||
        locationText.isEmpty) {
      Get.snackbar('Error', 'Please fill in all the details.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    // Parse the location from the text input.
    GeoPoint? location;
    try {
      final parts = locationText.split(',');
      if (parts.length == 2) {
        final latitude = double.parse(parts[0].trim());
        final longitude = double.parse(parts[1].trim());
        location = GeoPoint(latitude, longitude);
      } else {
        Get.snackbar('Error', 'Please enter location as "latitude, longitude".');
        return;
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid location format. Please enter valid numbers.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'postalZip': postalZip,
        'location': location, // Save the location as a GeoPoint.
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar('Success', 'Your details have been updated.');
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to update details.');
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }

  @override
  void onClose() {
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalZipController.dispose();
    locationController.dispose();
    super.onClose();
  }
}
