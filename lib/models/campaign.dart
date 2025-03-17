import 'package:cloud_firestore/cloud_firestore.dart';

class Campaign {
  final String id;
  final String title;
  final String organisation;
  final String location;
  final String details;
  final DateTime createdAt;

  Campaign({
    required this.id,
    required this.title,
    required this.organisation,
    required this.location,
    required this.details,
    required this.createdAt,
  });

  factory Campaign.fromMap(Map<String, dynamic> data, String documentId) {
    return Campaign(
      id: documentId,
      title: data['title'] ?? '',
      organisation: data['organisation'] ?? '',
      location: data['location'] ?? '',
      details: data['details'] ?? '',
      // Convert Firestore Timestamp to DateTime.
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
