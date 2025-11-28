import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_note/models/user_model.dart';

class FirestoreUserHelper {
  final userRef = FirebaseFirestore.instance
      .collection('users_notes')
      .withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  Future<void> addOrUpdateUser(UserModel user) async {
    await userRef.doc(user.userId).set(user);
  }
}
