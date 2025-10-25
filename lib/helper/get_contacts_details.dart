import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_chat/global.dart';

Future<List<Map<String, dynamic>>> getContactsData(
  List<String> contactsEmails,
) async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final result = <Map<String, dynamic>>[];

  try {
    // 🔹 Step 1: Find the current user by email
    final userQuery = await usersRef
        .where('email', isEqualTo: Global.email)
        .limit(1)
        .get();

    final userDocId = userQuery.docs.first.id;
    final contactsRef = usersRef.doc(userDocId).collection('contacts');

    // 🔹 Step 2: Firestore `whereIn` limit = 10, so we batch
    const batchSize = 10;
    final futures = <Future<QuerySnapshot<Map<String, dynamic>>>>[];

    for (var i = 0; i < contactsEmails.length; i += batchSize) {
      final batch = contactsEmails.skip(i).take(batchSize).toList();
      futures.add(contactsRef.where('email', whereIn: batch).get());
    }

    // 🔹 Step 3: Wait for all batches to finish
    final snapshots = await Future.wait(futures);

    // 🔹 Step 4: Combine results
    for (var snapshot in snapshots) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        result.add({'email': data['email'], 'name': data['name']});
      }
    }
  } catch (e) {}

  return result;
}
