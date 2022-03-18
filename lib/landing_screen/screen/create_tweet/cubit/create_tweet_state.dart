part of 'create_tweet_cubit.dart';

@immutable
abstract class CreateTweetState {}

class CreateTweetInitial extends CreateTweetState {}

class UnAuthorized extends CreateTweetState {}

class CreatingTweet extends CreateTweetState {}

class CreatingTweetFailed extends CreateTweetState {}

class TweetCreated extends CreateTweetState {}
