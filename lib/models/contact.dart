class Contact {
  final String email;
  final String name;

  Contact({required this.email, required this.name});

  factory Contact.fromJson(Map<String, dynamic> data) {
    return Contact(email: data['email'], name: data['name']);
  }
}
