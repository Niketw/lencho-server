class AuthUser {
  final String uid;
  final String email;
  final String name; // Optional: add other fields as needed

  AuthUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
    );
  }
}
