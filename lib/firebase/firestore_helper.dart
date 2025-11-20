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
    return docRef.id;
  }

  // * Fungsi get notes
  Future<List<NoteModel>> getAllNotes() async {
    final dataSnapshot = await noteRef.get();
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
}
