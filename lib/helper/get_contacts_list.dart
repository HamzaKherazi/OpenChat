import 'package:scholar_chat/models/contact.dart';

List<Contact> getContactsList(List<Map<String, dynamic>> contactsList) {
  List<Contact> cl = [];
  for (var element in contactsList) {
    cl.add(
      Contact(
        email: element['email'].toString(),
        name: element['name'].toString(),
      ),
    );
  }

  return cl;
}
