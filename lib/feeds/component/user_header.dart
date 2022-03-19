import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/feeds/cubit/tweet_cubit.dart';
import 'package:twitter_clone/model/user_profile_model.dart';

class UserHeader extends StatefulWidget {
  final String userId;
  const UserHeader({required this.userId, Key? key}) : super(key: key);

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/profile", arguments: widget.userId);
      },
      child: FutureBuilder<UserProfileModel?>(
        future:
            BlocProvider.of<TweetCubit>(context).getUserProfile(widget.userId),
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
                            placeholder: (context, url) => Shimmer.fromColors(
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
    );
  }
}
