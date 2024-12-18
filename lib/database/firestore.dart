import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesync/shared/toast.dart';

class FirestoreService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // Add Notes to Database
  Future<void> addNotes(String title, String body) async {
    try {
      const defaultTitle = "No Title, Update";
      await notes.add({
        'title': title.isNotEmpty == true ? title : defaultTitle,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(), // Only use the Timestamp
      });
      showToast(message: "Note added successfully!");
    } catch (e) {
      showToast(message: "Failed to add note: $e");
    }
  }

  // Fetch Notes From Database
  Stream<List<Map<String, dynamic>>> fetchNotes() {
    return notes
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return {
                'id': doc.id,
                'title': doc['title'],
                'body': doc['body'],
                'timestamp': doc['timestamp'], // Fetch the timestamp
              };
            }).toList());
  }

  // Update Notes in Database
  Future<void> updateNote(String id, String title, String body) async {
    try {
      await notes.doc(id).update({
        'title': title,
        'body': body,
      });
      showToast(message: "Note updated successfully!");
    } catch (e) {
      showToast(message: "Failed to update note: $e");
    }
  }

  // Delete Notes in Database
  Future<void> deleteNote(String id) async {
    try {
      await notes.doc(id).delete();
      showToast(message: "Note deleted successfully!");
    } catch (e) {
      showToast(message: "Failed to delete note: $e");
    }
  }
}
