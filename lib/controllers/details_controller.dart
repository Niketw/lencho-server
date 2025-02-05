import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart'; // Add geolocator import

class DetailsController extends GetxController {
  // Controllers for each extra detail.
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalZipController = TextEditingController();

  /// Retrieves the user's current location as a GeoPoint.
  Future<GeoPoint?> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions are permanently denied.');
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return GeoPoint(position.latitude, position.longitude);
    } catch (e) {
      Get.snackbar('Error', 'Could not retrieve location.');
      return null;
    }
  }

  /// Submits the details to Firestore for the current user.
  Future<void> submitDetails() async {
    final streetAddress = streetAddressController.text.trim();
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final postalZip = postalZipController.text.trim();

    if (streetAddress.isEmpty ||
        city.isEmpty ||
        state.isEmpty ||
        postalZip.isEmpty) {
      Get.snackbar('Error', 'Please fill in all the details.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'User not logged in.');
      return;
    }

    // Retrieve the current location.
    GeoPoint? location = await _getUserLocation();

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'postalZip': postalZip,
        'location': location, // Save the location (could be null if not available)
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
    super.onClose();
  }
}
