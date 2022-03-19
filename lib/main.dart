import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/auth/auth.dart';
import 'package:twitter_clone/auth/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter_clone/feeds/cubit/tweet_cubit.dart';
import 'package:twitter_clone/feeds/reply_tweet_screen.dart';
import 'package:twitter_clone/feeds/tweet_replies_screen.dart';
import 'package:twitter_clone/landing_screen/cubit/home_cubit.dart';
import 'package:twitter_clone/landing_screen/screen/create_tweet/create_tweet_screen.dart';
import 'package:twitter_clone/landing_screen/screen/create_tweet/cubit/create_tweet_cubit.dart';
import 'package:twitter_clone/landing_screen/screen/landing_screen.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/image_repository.dart';
import 'package:twitter_clone/repository/profile_repository.dart';
import 'package:twitter_clone/repository/tweet_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(
              builder: (context) => BlocProvider<AuthCubit>(
                  create: (context) => AuthCubit(AuthRepository()),
                  child: const Auth()),
            );

          case "/home":
            return MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<HomeCubit>(
                      create: (context) => HomeCubit(
                          imageRepository: ImageRepository(),
                          profileRepository: ProfileRepository(),
                          authRepository: AuthRepository())),
                  BlocProvider<TweetCubit>(
                      create: (context) => TweetCubit(
                          profileRepository: ProfileRepository(),
                          tweetRepository: TweetRepository(),
                          authRepository: AuthRepository()))
                ],
                child: const HomeScreen(),
              ),
            );
          case "/createTweet":
            return MaterialPageRoute(
              builder: (context) => BlocProvider<CreateTweetCubit>(
                create: (context) => CreateTweetCubit(
                    tweetRepository: TweetRepository(),
                    imageRepository: ImageRepository(),
                    authRepository: AuthRepository()),
                child: const CreateTweetScreen(),
              ),
            );
          case "/tweetReplies":
            return MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<TweetCubit>(
                      create: (context) => TweetCubit(
                          profileRepository: ProfileRepository(),
                          tweetRepository: TweetRepository(),
                          authRepository: AuthRepository()))
                ],
                child: const TweetRepliesScreen(),
              ),
            );
          case "/replyTweet":
            return MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<TweetCubit>(
                      create: (context) => TweetCubit(
                          profileRepository: ProfileRepository(),
                          tweetRepository: TweetRepository(),
                          authRepository: AuthRepository()))
                ],
                child: ReplyTweetScreen(
                  tweetModel: settings.arguments as TweetModel,
                ),
              ),
            );

          default:
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
