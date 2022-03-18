part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class CheckingIfProfileExists extends HomeState {}

class ProfileCheckResult extends HomeState {
  final bool profileExist;

  ProfileCheckResult(this.profileExist);
}

class CheckingProfileExistenceFailed extends HomeState {}

class CreatingProfile extends HomeState {}

class CreatingProfileFailed extends HomeState {}

class ProfileCreated extends HomeState {}

class UnAuthorized extends HomeState {}
