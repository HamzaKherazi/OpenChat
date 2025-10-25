import 'package:scholar_chat/global.dart';

String getContactEmail(String chatID) {
  final parts = chatID.split('_');

  // If Global.email is the first part
  if (parts.first == Global.email) {
    return parts.last; // the contact’s email
  }

  // Otherwise, your email is the second part
  return parts.first;
}
