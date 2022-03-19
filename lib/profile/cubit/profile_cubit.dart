import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/model/user_profile_model.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/profile_repository.dart';
import 'package:twitter_clone/repository/tweet_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final TweetRepository tweetRepository;
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;
  ProfileCubit(
      {required this.authRepository,
      required this.profileRepository,
      required this.tweetRepository})
      : super(ProfileInitial());

  Stream<UserProfileModel>? profile(String? uid) {
    User? user = authRepository.getUser();
    if (user == null) {
      emit(UnAuthorized());
    } else {
      return profileRepository
          .profileSnapshot(uid ?? user.uid)
          .transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (data.exists) {
            sink.add(UserProfileModel(
                firstName: data.data()!['firstName'],
                lastName: data.data()!['lastName'],
                userName: data.data()!['userName'],
                profilePic: data.data()!['profilePic']));
          }
        },
      ));
    }
  }

  bool? isMyProfile(String? uid) {
    if (uid == null) return true;
    User? user = authRepository.getUser();
    if (user == null) {
      emit(UnAuthorized());
    } else {
      return uid == user.uid;
    }
  }

  Stream<Map<String, dynamic>?>? followStatus(
    String uid,
  ) {
    User? user = authRepository.getUser();
    if (user == null) {
      emit(UnAuthorized());
    } else {
      return profileRepository
          .followStatus(user.uid, uid)
          .transform(StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          if (data.docs.isNotEmpty) {
            sink.add(data.docs.first.data());
          } else {
            sink.add(null);
          }
        },
      ));
    }
  }

  toggleFollowUnfollow(String uid, bool follow) {
    User? user = authRepository.getUser();
    if (user == null) {
      emit(UnAuthorized());
    } else {
      profileRepository.toggleFollowUnfollow(user.uid, uid, follow);
    }
  }
}
