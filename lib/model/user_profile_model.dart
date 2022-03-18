class UserProfileModel {
  final String firstName;
  final String lastName;
  final String userName;
  final String? profilePic;

  UserProfileModel(
      {required this.firstName,
      required this.lastName,
      required this.userName,
      this.profilePic});
}
