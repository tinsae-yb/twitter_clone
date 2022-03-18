import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/image_repository.dart';
import 'package:twitter_clone/repository/profile_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ProfileRepository profileRepository;
  final AuthRepository authRepository;
  final ImageRepository imageRepository;
  HomeCubit(
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
}
