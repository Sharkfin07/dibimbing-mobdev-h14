import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note/models/note_model.dart';

class FirestoreHelper {
  final noteRef = FirebaseFirestore.instance
      .collection("notes")
      .withConverter<NoteModel>(
        fromFirestore: (snapshots, _) => NoteModel.fromJson(snapshots.data()!),
        toFirestore: (note, _) => note.toJson(),
      );

  // * Fungsi add notes
  Future addNote(NoteModel note) async {
    final docRef = await noteRef.add(note);
    final noteRefUpdated = noteRef.doc(docRef.id);
    noteRefUpdated.update({'note_id': docRef.id});
    return docRef.id;
  }

  // * Fungsi get notes
  Future<List<NoteModel>> getAllNotes() async {
    final dataSnapshot = await noteRef
        .orderBy("updated_at", descending: true)
        .get();
    return dataSnapshot.docs.map((doc) {
      final note = doc.data();
      note.noteId = doc.id;
      return note;
    }).toList();
  }

  // * Fungsi menghapus note
  Future<void> removeNote(String noteId) async {
    await noteRef.doc(noteId).delete();
  }

  // * Fungsi update note
  Future<void> updateNote(String noteId, NoteModel note) async {
    await noteRef.doc(noteId).set(note);
  }

  // * Stream
  Stream<QuerySnapshot<NoteModel>> getNoteStream() {
    return noteRef.snapshots();
  }
}
