import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/model/user_profile_model.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/image_repository.dart';
import 'package:twitter_clone/repository/profile_repository.dart';

part 'landing_state.dart';

class LandingCubit extends Cubit<LandingState> {
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;
  final ImageRepository imageRepository;
  LandingCubit(
      {required this.profileRepository,
      required this.authRepository,
      required this.imageRepository})
      : super(HomeInitial());

  checkUserProfileExists() async {
    try {
      emit(CheckingIfProfileExists());

      User? user = authRepository.getUser();
      if (user == null) {
        emit(UnAuthorized());
      } else {
        bool userExists = await profileRepository.userProfileExists(user.uid);
        emit(ProfileCheckResult(userExists));
      }
    } catch (e) {
      emit(CheckingProfileExistenceFailed());
    }
  }

  finishCreatingProfile(String firstName, String lastName, String userName,
      String? filePath) async {
    try {
      emit(CreatingProfile());

      User? user = authRepository.getUser();
      if (user == null) {
        emit(UnAuthorized());
      } else {
        String? imageDownloadurl;
        if (filePath != null) {
          imageDownloadurl =
              await imageRepository.uploadPicture(File(filePath));
        }

        await profileRepository.createProfile(
            user.uid, firstName, lastName, userName, imageDownloadurl);
        emit(ProfileCreated());
      }
    } catch (e) {
      emit(CreatingProfileFailed());
    }
  }

  Future<XFile?> pickImage(bool fromCamera) async {
    XFile? xfile = await imageRepository.pickImage(fromCamera);
    return xfile;
  }

  Stream<UserProfileModel>? myProfileSnapshot() {
    User? user = authRepository.getUser();
    if (user == null) {
      emit(UnAuthorized());
    } else {
      return profileRepository
          .profileSnapshot(user.uid)
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
}
