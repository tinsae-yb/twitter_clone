import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/image_repository.dart';
import 'package:twitter_clone/repository/tweet_repository.dart';

part 'create_tweet_state.dart';

class CreateTweetCubit extends Cubit<CreateTweetState> {
  final AuthRepository authRepository;
  final TweetRepository tweetRepository;
  final ImageRepository imageRepository;
  CreateTweetCubit(
      {required this.authRepository,
      required this.tweetRepository,
      required this.imageRepository})
      : super(CreateTweetInitial());

  Future<XFile?> pickImage(bool fromCamera) async {
    XFile? xfile = await imageRepository.pickImage(fromCamera);
    return xfile;
  }

  createTweet(String tweet, String? filePath) async {
    try {
      emit(CreatingTweet());
      User? user = authRepository.getUser();
      if (user == null) {
        emit(UnAuthorized());
      } else {
        String? imageDownloadurl;
        if (filePath != null) {
          imageDownloadurl =
              await imageRepository.uploadPicture(File(filePath));
        }
        await tweetRepository.createTweet(user.uid, tweet, imageDownloadurl);
        emit(TweetCreated());
      }
    } catch (e) {
      emit(CreatingTweetFailed());
    }
  }
}
