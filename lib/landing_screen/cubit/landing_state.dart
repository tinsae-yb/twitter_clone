part of 'landing_cubit.dart';

@immutable
abstract class LandingState {}

class HomeInitial extends LandingState {}

class CheckingIfProfileExists extends LandingState {}

class ProfileCheckResult extends LandingState {
  final bool profileExist;

  ProfileCheckResult(this.profileExist);
}

class CheckingProfileExistenceFailed extends LandingState {}

class CreatingProfile extends LandingState {}

class CreatingProfileFailed extends LandingState {}

class ProfileCreated extends LandingState {}

class UnAuthorized extends LandingState {}

