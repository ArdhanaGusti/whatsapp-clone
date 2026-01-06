class Chat {
  final int id;
  final String message;
  final String oppositeName;
  final bool isSender;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final DateTime? deletedAt;

  Chat({
    required this.id,
    required this.message,
    required this.oppositeName,
    required this.isSender,
    // required this.createdAt,
    // required this.updatedAt,
    // this.deletedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      message: json['message'],
      oppositeName: json['opposite_name'],
      isSender: json['is_sender'],
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
      // deletedAt: json['deleted_at'],
    );
  }
}
