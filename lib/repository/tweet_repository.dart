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
      "comments": 0,
      "likes": 0,
      "createdAt": FieldValue.serverTimestamp()
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> feeds() {
    return _firebaseFirestore
        .collection("Tweets")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> likedByUser(
      String userId, String postId) {
    return _firebaseFirestore
        .collection("Tweets")
        .doc(postId)
        .collection("Likes")
        .doc("userId")
        .snapshots();
  }

  toggleTweetLike(bool like, String userId, String postId) {
    WriteBatch batch = _firebaseFirestore.batch();
    if (!like) {
      batch.delete(_firebaseFirestore
          .collection("Tweets")
          .doc(postId)
          .collection("Likes")
          .doc("userId"));
      batch.update(_firebaseFirestore.collection("Tweets").doc(postId),
          {"likes": FieldValue.increment(-1)});
    } else {
      batch.set(
          _firebaseFirestore
              .collection("Tweets")
              .doc(postId)
              .collection("Likes")
              .doc("userId"),
          {"createdAt": FieldValue.serverTimestamp()});
      batch.update(_firebaseFirestore.collection("Tweets").doc(postId),
          {"likes": FieldValue.increment(1)});
    }

    batch.commit();
  }

  createTweetReply(String reply, String userId, String postId) {
    WriteBatch batch = _firebaseFirestore.batch();

    batch.set(
        _firebaseFirestore
            .collection("Tweets")
            .doc(postId)
            .collection("Comments")
            .doc(),
        {
          "reply": reply,
          "author": userId,
          "createdAt": FieldValue.serverTimestamp()
        });

    batch.update(_firebaseFirestore.collection("Tweets").doc(postId),
        {"comments": FieldValue.increment(1)});

    batch.commit();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> tweetReplies(String tweetId) {
    return _firebaseFirestore
        .collection("Tweets")
        .doc(tweetId)
        .collection("Comments")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
