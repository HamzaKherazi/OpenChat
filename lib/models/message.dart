import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_chat/constants.dart';

class Message {
  final String content;
  final String sender;
  final DateTime createdAt;

  Message({
    required this.content,
    required this.sender,
    required this.createdAt,
  });

  factory Message.fromJson(data) {
    return Message(
      content: data[kContent],
      sender: data[kSender],
      createdAt: data[kCreatedAt] is Timestamp
          ? data[kCreatedAt].toDate()
          : DateTime.now(),
    );
  }
}
