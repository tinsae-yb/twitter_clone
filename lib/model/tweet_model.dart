import 'package:cloud_firestore/cloud_firestore.dart';

class TweetModel {
  final String id;
  final String tweet;
  final String author;
  final String? image;
  final Timestamp createdAt;
  final num comments;
  final num likes;

  TweetModel(
      {required this.tweet,
      required this.author,
      required this.id,
      required this.image,
      required this.createdAt,
      required this.comments,
      required this.likes});
}
