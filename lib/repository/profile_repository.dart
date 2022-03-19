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
        .get(const GetOptions(source: Source.serverAndCache));
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> profileSnapshot(String uid) {
    return _firebaseFirestore.collection("Users").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> followStatus(
    String follower,
    String user,
  ) {
    return _firebaseFirestore
        .collection("follows")
        .where("follower", isEqualTo: follower)
        .where("user", isEqualTo: user)
        .limit(1)
        .snapshots();
  }

  Future<void> toggleFollowUnfollow(
      String follower, String user, bool follow) async {
    if (follow) {
      return _firebaseFirestore
          .collection("follows")
          .doc()
          .set({"follower": follower, "user": user, "following": true});
    } else {
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection("follows")
          .where("follower", isEqualTo: follower)
          .where("user", isEqualTo: user)
          .get();
      for (DocumentSnapshot item in querySnapshot.docs) {
        await item.reference.delete();
      }
    }
  }
}
