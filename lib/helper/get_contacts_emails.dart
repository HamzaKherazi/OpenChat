import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_chat/global.dart';
import 'package:scholar_chat/helper/get_contact_email.dart';

Future<List<String>> getContactsEmails() async {
  final chatsRef = FirebaseFirestore.instance.collection('chats');

  // Fetch all chat documents
  final querySnapshot = await chatsRef.get();

  // Filter only chats where the ID includes my email
  final myChats = querySnapshot.docs
      .where((doc) => doc.id.contains(Global.email!))
      .toList();

  // Extract contact emails from chat IDs
  final contactsEmails = myChats.map((doc) {
    return getContactEmail(doc.id);
  }).toList();

  return contactsEmails;
}
