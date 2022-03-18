import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/feeds/cubit/feeds_cubit.dart';
import 'package:twitter_clone/model/tweet_model.dart';
import 'package:twitter_clone/model/user_profile_model.dart';

class FeedComponent extends StatefulWidget {
  final TweetModel tweetModel;
  const FeedComponent({Key? key, required this.tweetModel}) : super(key: key);

  @override
  State<FeedComponent> createState() => _FeedComponentState();
}

class _FeedComponentState extends State<FeedComponent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<UserProfileModel?>(
            future: BlocProvider.of<FeedsCubit>(context)
                .getUserProfile(widget.tweetModel.author),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: snapshot.data?.profilePic == null
                            ? Container()
                            : CachedNetworkImage(
                                imageUrl: snapshot.data!.profilePic!,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
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
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text((snapshot.data?.firstName ?? " ") +
                            " " +
                            (snapshot.data?.lastName ?? " ")),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                        ),
                        Text("@" + (snapshot.data?.userName ?? "")),
                      ],
                    )
                  ],
                );
              }
              return Shimmer.fromColors(
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 120, height: 8, color: Colors.white),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                        ),
                        Container(width: 80, height: 8, color: Colors.white),
                      ],
                    )
                  ],
                ),
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
              );
            },
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
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
