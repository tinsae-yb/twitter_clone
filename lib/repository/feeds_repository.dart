import 'package:cloud_firestore/cloud_firestore.dart';

class FeedsRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot<Map<String, dynamic>>> feeds() {
    return _firebaseFirestore
        .collection("Tweets")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
