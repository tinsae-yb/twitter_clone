part of 'tweet_cubit.dart';

@immutable
abstract class TweetState {}

class TweetsInitial extends TweetState {}

class UnAuthorized extends TweetState {}

class TweetReplied extends TweetState {}

class TweetReplyFailed extends TweetState {}

class ReplyingTweet extends TweetState {}
