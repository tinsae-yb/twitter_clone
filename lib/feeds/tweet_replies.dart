import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/feeds/component/tweet_component.dart';
import 'package:twitter_clone/feeds/component/user_header.dart';
import 'package:twitter_clone/feeds/cubit/tweet_cubit.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/tweet_reply_model.dart';

class TweetReplies extends StatefulWidget {
  final TweetModel tweetModel;
  const TweetReplies({required this.tweetModel, Key? key}) : super(key: key);

  @override
  State<TweetReplies> createState() => _TweetRepliesState();
}

class _TweetRepliesState extends State<TweetReplies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        centerTitle: true,
        title: Text(
          "Replies",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TweetComponent(
                tweetModel: widget.tweetModel,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder<List<TweetReplyModel>>(
                  stream: BlocProvider.of<TweetCubit>(context)
                      .tweetReplies(widget.tweetModel.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          for (TweetReplyModel item in snapshot.data ?? [])
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserHeader(userId: item.authorId),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 70,
                                  ),
                                  child: Text(item.reply),
                                ),
                                const Divider(
                                  indent: 70,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 70,
                                  ),
                                  child: Text(
                                    DateFormat(DateFormat
                                            .YEAR_ABBR_MONTH_WEEKDAY_DAY)
                                        .format(item.timestamp.toDate()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(color: Colors.grey),
                                  ),
                                ),
                                const Divider(),
                              ],
                            )
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
