import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:norq_technologies/controller/auth_provider.dart';

final currentuserId = FirebaseAuth.instance.currentUser!.uid;

class FirestoreService {
  final CollectionReference doctorCollection =
      FirebaseFirestore.instance.collection('Userdetails');

  Future<void> createUser(ProfileModel user) async {
    try {
      final docUser =
          FirebaseFirestore.instance.collection('Userdetails').doc(user.uid);
      user.uid = docUser.id;
      final json = user.toJson();
      await docUser.set(json);
    } catch (error) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileStream() {
    final currentUserId = getCurrentUserId();
    final profileStream = FirebaseFirestore.instance
        .collection('Userdetails')
        .doc(currentUserId)
        .snapshots();

    return profileStream;
  }

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }
}
