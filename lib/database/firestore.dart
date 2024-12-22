import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  // Add Note
  Future<void> addNote({
    required String title,
    required String body,
    required bool isPublic,
  }) async {
    if (userId.isEmpty) {
      throw Exception("User not authenticated");
    }

    await _firestore.collection('notes').add({
      'userId': userId,
      'title': title,
      'body': body,
      'isPublic': isPublic,
      'date': FieldValue.serverTimestamp(),
    });
  }

  // Fetch user-specific notes
  Stream<List<Map<String, dynamic>>> fetchMyNotes() {
    if (userId.isEmpty) {
      throw Exception("User not authenticated");
    }

    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  // Fetch Public Notes
  Stream<List<Map<String, dynamic>>> fetchOtherNotes() {
    return _firestore
        .collection('notes')
        .where('isPublic', isEqualTo: true)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  //Update Notes
  Future<void> updateNote(
    String noteId,
    String title,
    String body,
    bool isPublic,
  ) async {
    if (userId.isEmpty) throw Exception("User not authenticated");

    await _firestore.collection('notes').doc(noteId).update({
      'title': title,
      'body': body,
      'isPublic': isPublic,
    });
  }

  // Update Note Visibility
  Future<void> updateNoteVisibility(String noteId, bool isPublic) async {
    await _firestore.collection('notes').doc(noteId).update({
      'isPublic': isPublic,
    });
  }

  // Delete Note
  Future<void> deleteNote(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
  }
}
