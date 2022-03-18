import 'package:cloud_firestore/cloud_firestore.dart';

class TweetModel {
  final String tweet;
  final String author;
  final String? image;
  final Timestamp createdAt;

  TweetModel(this.tweet, this.author, this.image, this.createdAt);
}
