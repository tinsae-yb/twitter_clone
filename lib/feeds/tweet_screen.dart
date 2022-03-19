import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/feeds/component/feeds_shimmer.dart';
import 'package:twitter_clone/feeds/component/tweet_component.dart';
import 'package:twitter_clone/feeds/cubit/tweet_cubit.dart';
import 'package:twitter_clone/model/tweet_model.dart';

class TweetScreen extends StatefulWidget {
  const TweetScreen({Key? key}) : super(key: key);

  @override
  State<TweetScreen> createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<List<TweetModel>>(
        stream: BlocProvider.of<TweetCubit>(context).feeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const FeedsShimmer();
          }

          if (snapshot.hasData) {
            return ListView.builder(
              cacheExtent: size.height * 3,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/tweetReplies",
                        arguments: snapshot.data![index]);
                  },
                  child: TweetComponent(tweetModel: snapshot.data![index])),
            );
          }
          return const Center(
            child: Text("Feeds"),
          );
        });
  }
}
