import 'package:cloud_firestore/cloud_firestore.dart';

class TweetReplyModel {
  final String replyId;
  final String authorId;
  final String reply;
  final Timestamp timestamp;

  TweetReplyModel(
      {required this.replyId,
      required this.authorId,
      required this.reply,
      required this.timestamp});
}
