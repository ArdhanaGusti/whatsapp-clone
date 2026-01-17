class Profile {
  final int id;
  final String username;
  final String email;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final DateTime? deletedAt;

  Profile({
    required this.id,
    required this.username,
    required this.email,
    // required this.createdAt,
    // required this.updatedAt,
    // this.deletedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['ID'],
      username: json['Username'],
      email: json['Email']
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
      // deletedAt: json['deleted_at'],
    );
  }
}
