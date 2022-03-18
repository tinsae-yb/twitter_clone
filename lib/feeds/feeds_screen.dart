import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/feeds/component/feed_component.dart';
import 'package:twitter_clone/feeds/component/feeds_shimmer.dart';
import 'package:twitter_clone/feeds/cubit/feeds_cubit.dart';
import 'package:twitter_clone/model/tweet_model.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return StreamBuilder<List<TweetModel>>(
        stream: BlocProvider.of<FeedsCubit>(context).feeds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const FeedsShimmer();
          }

          if (snapshot.hasData) {
            return ListView.builder(
              cacheExtent: size.height * 3,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) =>
                  FeedComponent(tweetModel: snapshot.data![index]),
            );
          }
          return Center(
            child: Text("Feeds"),
          );
        });
  }
}
