import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/global.dart';
import 'package:scholar_chat/helper/get_contact_email.dart';
import 'package:scholar_chat/helper/get_contacts_details.dart';
import 'package:scholar_chat/helper/get_contacts_list.dart';
import 'package:scholar_chat/screens/contacts_screen.dart';
import 'package:scholar_chat/widgets/contacts_listview.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream<QuerySnapshot>? _chatsStream;

  @override
  void initState() {
    super.initState();
    _chatsStream = FirebaseFirestore.instance
        .collection('chats')
        .orderBy(kCreatedAt, descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Chats',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, ContactsScreen.id),
        child: const Icon(Icons.chat, size: 26),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _chatsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats.'));
          }

          final myChats = snapshot.data!.docs
              .where((doc) => doc.id.contains(Global.email!))
              .toList();

          if (myChats.isEmpty) {
            return const Center(child: Text('No chats.'));
          }

          final contactsEmails = myChats
              .map((doc) => getContactEmail(doc.id))
              .toList();

          // Fetch user details
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: getContactsData(contactsEmails),
            builder: (context, contactSnapshot) {
              if (contactSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (contactSnapshot.hasError) {
                return Center(child: Text('Error: ${contactSnapshot.error}'));
              }
              if (!contactSnapshot.hasData || contactSnapshot.data!.isEmpty) {
                return const Center(child: Text('No chats.'));
              }

              final contactsList = getContactsList(contactSnapshot.data!);

              return ContactsListView(contactsList: contactsList);
            },
          );
        },
      ),
    );
  }
}
