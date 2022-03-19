import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/landing_screen/cubit/landing_cubit.dart';
import 'package:twitter_clone/model/user_profile_model.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<UserProfileModel>(
        stream: BlocProvider.of<LandingCubit>(context).myProfileSnapshot(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(
                  "Twitter clone",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Icon(Icons.stars)
              ],
            ),
          );
        },
      ),
    );
  }
}
