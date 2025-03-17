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

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'organisation': organisation,
      'location': location,
      'details': details,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Campaign.fromMap(Map<String, dynamic> map, String documentId) {
    return Campaign(
      id: documentId,
      title: map['title'] ?? '',
      organisation: map['organisation'] ?? '',
      location: map['location'] ?? '',
      details: map['details'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }
}
