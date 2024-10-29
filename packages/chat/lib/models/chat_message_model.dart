class MessageModel {
  final String senderId;
  final String receiverId;
  final String senderName;
  final String content;
  final bool seen;
  final DateTime sentTime;
  final MessageType messageType;

  const MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.sentTime,
    required this.content,
    required this.seen,
    required this.messageType,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        senderName: json['senderName']??"",
        sentTime: json['sentTime'].toDate(),
        content: json['content'],
        seen: json['seen'] ?? false,
        messageType: MessageType.fromJson(json['messageType']),
      );

  Map<String, dynamic> toJson() => {
        'receiverId': receiverId,
        'senderId': senderId,
        'senderName': senderName,
        'sentTime': sentTime,
        'content': content,
        'seen': seen,
        'messageType': messageType.toJson(),
      };
}

enum MessageType {
  text,
  image,
  audio;

  String toJson() => name;

  factory MessageType.fromJson(String json) => values.byName(json);
}
