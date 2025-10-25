import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/models/contact.dart';
import 'package:scholar_chat/screens/chat_screen.dart';

class ContactItem extends StatelessWidget {
  ContactItem({super.key, required this.contact, this.onTap});

  final Contact contact;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: kPictureColor,
              child: Text(
                contact.name.trimLeft()[0].toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            title: Text(contact.name, style: TextStyle(fontSize: 18)),
          ),
          Divider(indent: 10, endIndent: 10),
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.id, arguments: contact);
      },
    );
  }
}
