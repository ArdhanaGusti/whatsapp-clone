class ChatDetail {
  final int id;
  final String message;
  final bool isMe;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final DateTime? deletedAt;

  ChatDetail({
    required this.id,
    required this.message,
    required this.isMe,
    // required this.createdAt,
    // required this.updatedAt,
    // this.deletedAt,
  });

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      id: json['id'],
      message: json['message'],
      isMe: json['is_me'],
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
      // deletedAt: json['deleted_at'],
    );
  }
}
