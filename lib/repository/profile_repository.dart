import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> userProfileExists(String uid) async {
    DocumentSnapshot userDocSnap =
        await _firebaseFirestore.collection("Users").doc(uid).get();
    return userDocSnap.exists;
  }

  createProfile(String uid, String firstName, String lastName, String userName,
      String? imageDownloadurl) {
    return _firebaseFirestore.collection("Users").doc(uid).set({
      "firstName": firstName,
      "lastName": lastName,
      "userName": userName,
      "profilePic": imageDownloadurl
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchProfile(String uid) {
    return _firebaseFirestore
        .collection("Users")
        .doc(uid)
        .get(GetOptions(source: Source.serverAndCache));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> profileSnapshot(String uid) {
    return _firebaseFirestore.collection("Users").doc(uid).snapshots();
  }
}
