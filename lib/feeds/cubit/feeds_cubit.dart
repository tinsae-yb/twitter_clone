import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/user_profile_model.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/feeds_repository.dart';
import 'package:twitter_clone/repository/profile_repository.dart';

part 'feeds_state.dart';

class FeedsCubit extends Cubit<FeedsState> {
  final FeedsRepository feedsRepository;
  final AuthRepository authRepository;
  final ProfileRepository profileRepository;
  FeedsCubit(
      {required this.authRepository,
      required this.profileRepository,
      required this.feedsRepository})
      : super(FeedsInitial());

  Stream<List<TweetModel>> feeds() {
    return feedsRepository
        .feeds()
        .transform<List<TweetModel>>(StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        sink.add(data.docs.map((e) {
          Map<String, dynamic> data = e.data();

          return TweetModel(data['tweet'], data['author'], data['imageUrl'],
              data['createdAt']);
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
}
