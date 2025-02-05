import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String uid;
  final String streetAddress;
  final String city;
  final String state;
  final String postalZip;
  final DateTime? updatedAt;

  UserDetails({
    required this.uid,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalZip,
    this.updatedAt,
  });

  // Create a UserDetails instance from a Firestore document.
  factory UserDetails.fromMap(Map<String, dynamic> map, String documentId) {
    return UserDetails(
      uid: documentId,
      streetAddress: map['streetAddress'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postalZip: map['postalZip'] ?? '',
      updatedAt: map['updatedAt'] != null
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert a UserDetails instance into a Map for saving to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'postalZip': postalZip,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}
