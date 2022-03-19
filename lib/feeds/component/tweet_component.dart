import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/feeds/component/user_header.dart';
import 'package:twitter_clone/feeds/cubit/tweet_cubit.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/user_profile_model.dart';

class TweetComponent extends StatefulWidget {
  final TweetModel tweetModel;
  const TweetComponent({Key? key, required this.tweetModel}) : super(key: key);

  @override
  State<TweetComponent> createState() => _TweetComponentState();
}

class _TweetComponentState extends State<TweetComponent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserHeader(
            userId: widget.tweetModel.author,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tweetModel.tweet,
                  textAlign: TextAlign.left,
                ),
                if (widget.tweetModel.image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.tweetModel.image!,
                        placeholder: (context, url) => Shimmer.fromColors(
                          child: Container(
                            width: double.infinity,
                            height: size.height * 0.4,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const Divider(),
                Text(
                  DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                      .format(widget.tweetModel.createdAt.toDate()),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: Colors.grey),
                ),
                const Divider(),
                Row(
                  children: [
                    StreamBuilder<Map<String, dynamic>?>(
                        stream: BlocProvider.of<TweetCubit>(context)
                            .isTweetLiked(widget.tweetModel.id),
                        builder: (context, snapshot) {
                          return InkWell(
                            onTap: () {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                BlocProvider.of<TweetCubit>(context)
                                    .toggleTweet(!snapshot.hasData,
                                        widget.tweetModel.id);
                              }
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  color: snapshot.hasData
                                      ? Theme.of(context).primaryColor
                                      : Colors.black,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("${widget.tweetModel.likes}")
                              ],
                            ),
                          );
                        }),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/replyTweet",
                            arguments: widget.tweetModel);
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.comment_bank_outlined),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("${widget.tweetModel.comments}")
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
