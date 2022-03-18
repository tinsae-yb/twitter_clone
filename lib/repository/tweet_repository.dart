import 'package:cloud_firestore/cloud_firestore.dart';

class TweetRepository {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Future createTweet(
    String author,
    String tweet,
    String? imageUrl,
  ) async {
    return _firebaseFirestore.collection("Tweets").doc().set({
      "author": author,
      "tweet": tweet,
      "imageUrl": imageUrl,
      "createdAt": FieldValue.serverTimestamp()
    });
  }
}
