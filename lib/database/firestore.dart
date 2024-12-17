import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesync/shared/toast.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  //Add Notes To DataBase
  Future<void> addNotes(String title, String body) async {
    try {
      await notes.add({
        'title': title,
        'body': body,
        'date': DateTime.now().toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      showToast(message: "Note added successfully!");
    } catch (e) {
      showToast(message: "Failed to add note: $e");
    }
  }

  //Fetch Notes From DataBase

  //Update Notes From DataBase
}
