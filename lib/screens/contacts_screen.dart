import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat/constants.dart';
import 'package:scholar_chat/global.dart';
import 'package:scholar_chat/helper/get_contacts_list.dart';
import 'package:scholar_chat/screens/add_contact_screen.dart';
import 'package:scholar_chat/widgets/contacts_listview.dart';

class ContactsScreen extends StatefulWidget {
  static String id = 'ContactsScreen';

  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late final Future<String?> _userIdFuture;
  Stream<QuerySnapshot>? _contactsStream;

  @override
  void initState() {
    super.initState();
    _userIdFuture = _getUserId(Global.email!).then((userId) {
      if (userId != null) {
        _contactsStream = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('contacts')
            .orderBy('name')
            .snapshots();
      }
      return userId;
    });
  }

  bool isSearching = false;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _userIdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              title: const Text(
                "Contacts",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('no data.'));
        }
        final userId = snapshot.data!;

        return StreamBuilder<QuerySnapshot>(
          stream: _contactsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  title: const Text(
                    "Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  title: const Text(
                    "Contacts",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                body: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, AddContactScreen.id);
                      },
                      leading: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color.fromARGB(255, 5, 138, 255),
                        child: Icon(Icons.person_add, color: Colors.white),
                      ),
                      title: const Text(
                        'New contact',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 250),
                    const Center(child: Text("No contacts found")),
                  ],
                ),
              );
            }

            final contactsData = snapshot.data!.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
            final contactsList = getContactsList(contactsData);
            final contactsCount = contactsList.length;

            // ✅ Filter here, no setState
            final visibleContacts = searchQuery.isEmpty
                ? contactsList
                : contactsList
                      .where(
                        (c) => c.name.toLowerCase().startsWith(
                          searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();

            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                        searchQuery = '';
                        _searchController.clear();
                        if (isSearching) {
                          _searchFocusNode.requestFocus();
                        } else {
                          _searchFocusNode.unfocus();
                        }
                      });
                    },
                    icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
                  ),
                ],
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
                title: isSearching
                    ? TextField(
                        focusNode: _searchFocusNode,
                        controller: _searchController,
                        onChanged: (data) {
                          setState(() {
                            // ✅ Only update searchQuery, not rebuild stream
                            setState(() => searchQuery = data);
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: TextStyle(color: Colors.white60),
                          hintText: 'Search...',
                        ),
                        style: TextStyle(color: Colors.white),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contacts',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$contactsCount contacts',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
              ),
              body: ListView(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, AddContactScreen.id);
                    },
                    leading: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromARGB(255, 5, 138, 255),
                      child: Icon(Icons.person_add, color: Colors.white),
                    ),
                    title: const Text(
                      'New contact',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const Divider(indent: 10, endIndent: 10),
                  ContactsListView(contactsList: visibleContacts),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// get userId once (so we don’t re-run the query every rebuild)
  Future<String?> _getUserId(String email) async {
    final userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (userQuery.docs.isEmpty) return null;
    return userQuery.docs.first.id;
  }
}
