import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/global.dart';
import 'package:scholar_chat/helper/show_snack_bar.dart';
import 'package:scholar_chat/models/contact.dart';
import 'package:scholar_chat/widgets/custom_label.dart';

class AddContactScreen extends StatelessWidget {
  static String id = 'AddContactScreen';

  String? firstName;
  String? lastName;
  String? email;
  final _formKey = GlobalKey<FormState>();

  AddContactScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: kPrimaryColor,
        title: Text('Add New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 30, right: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomLabel(title: 'First name'),
              TextFormField(
                validator: (data) {
                  if (data!.isEmpty) {
                    return '⚠️ First name is required';
                  }
                  return null;
                },
                onChanged: (data) {
                  firstName = data;
                },
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(icon: Icon(Icons.person)),
              ),
              SizedBox(height: 50),
              CustomLabel(title: 'Last name'),

              TextFormField(
                validator: (data) {
                  if (data!.isEmpty) {
                    return '⚠️ Last name is required';
                  }
                  return null;
                },
                onChanged: (data) {
                  lastName = data;
                },
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(icon: Icon(Icons.person)),
              ),
              SizedBox(height: 50),
              CustomLabel(title: 'Email'),

              TextFormField(
                validator: (data) {
                  if (data == null || data.isEmpty) {
                    return '⚠️ Email is required';
                  }
                  // Simple regex for email validation
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(data)) {
                    return '⚠️ Enter a valid email address';
                  }
                  return null;
                },
                onChanged: (data) {
                  email = data;
                },
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(icon: Icon(Icons.email)),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 140, left: 40, right: 40),
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    Contact contact = Contact(
                      email: email!,
                      name: '${firstName!} ${lastName!}',
                    );

                    await addContact(context, contact);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    fixedSize: const Size(300, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addContact(context, Contact contact) async {
    final usersRef = FirebaseFirestore.instance.collection('users');

    // find the user document by email
    final userQuery = await usersRef
        .where('email', isEqualTo: Global.email)
        .get();

    final userDoc = userQuery.docs.first.reference;
    final contactsRef = userDoc.collection('contacts');

    // check if this contact already exists for that user
    final existing = await contactsRef
        .where('email', isEqualTo: contact.email)
        .get();

    if (existing.docs.isEmpty) {
      await contactsRef.add({'name': contact.name, 'email': contact.email});

      showSnackBar(
        context,
        message: 'Contact saved successfully!',
        color: Colors.teal,
      );
      Navigator.pop(context);
    } else {
      showSnackBar(
        context,
        message: '⚠️ Contact already exists',
        color: Colors.red,
      );
    }
  }
}
