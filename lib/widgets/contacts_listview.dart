import 'package:flutter/material.dart';
import 'package:scholar_chat/models/contact.dart';
import 'package:scholar_chat/widgets/contact_item.dart';

class ContactsListView extends StatelessWidget {
  const ContactsListView({super.key, required this.contactsList});

  final List<Contact> contactsList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: contactsList.length,
        itemBuilder: (context, index) {
          final element = contactsList[index];
          return ContactItem(
            contact: Contact(email: element.email, name: element.name),
          );
        },
      ),
    );
  }
}
