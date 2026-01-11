class Message {
  final String message;
  final int senderId;
  final int receiverID;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  // final DateTime? deletedAt;

  Message({
    required this.message,
    required this.senderId,
    required this.receiverID,
    // required this.createdAt,
    // required this.updatedAt,
    // this.deletedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['Message'],
      senderId: json['SenderID'],
      receiverID: json['ReceiverID']
      // createdAt: json['created_at'],
      // updatedAt: json['updated_at'],
      // deletedAt: json['deleted_at'],
    );
  }
}
