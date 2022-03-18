import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/user_profile_model.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/profile_repository.dart';
import 'package:twitter_clone/repository/tweet_repository.dart';

part 'tweet_state.dart';

class TweetCubit extends Cubit<TweetState> {
  final TweetRepository tweetRepository;
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  TweetCubit(
      {required this.authRepository,
      required this.profileRepository,
      required this.tweetRepository})
      : super(TweetsInitial());

  Stream<List<TweetModel>> feeds() {
    return tweetRepository
        .feeds()
        .transform<List<TweetModel>>(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data.docs.map((e) {
          Map<String, dynamic> data = e.data();

          return TweetModel(
              id: e.id,
              comments: data['comments'],
              likes: data['likes'],
              tweet: data['tweet'],
              author: data['author'],
              image: data['imageUrl'],
              createdAt: data['createdAt']);
        }).toList());
      },
    ));
  }

  Future<UserProfileModel?> getUserProfile(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> docSnap =
        await profileRepository.fetchProfile(uid);
    Map<String, dynamic>? data = docSnap.data();

    if (data != null) {
      return UserProfileModel(
          firstName: data["firstName"],
          lastName: data["lastName"],
          profilePic: data["profilePic"],
          userName: data["userName"]);
    }
  }

  Stream<Map<String, dynamic>?> isTweetLiked(String postId) {
    User? user = authRepository.getUser();
    return tweetRepository
        .likedByUser(user?.uid ?? "", postId)
        .transform(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data.data());
      },
    ));
  }

  toggleTweet(bool like, String postId) {
    User? user = authRepository.getUser();
    tweetRepository.toggleTweetLike(like, user?.uid ?? "", postId);
  }
}
