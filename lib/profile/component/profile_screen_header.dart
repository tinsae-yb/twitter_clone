import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/model/user_profile_model.dart';
import 'package:twitter_clone/profile/cubit/profile_cubit.dart';

class ProfileScreenHeader extends StatefulWidget {
  final String? uid;
  const ProfileScreenHeader({required this.uid, Key? key}) : super(key: key);

  @override
  State<ProfileScreenHeader> createState() => _ProfileScreenHeaderState();
}

class _ProfileScreenHeaderState extends State<ProfileScreenHeader> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: StreamBuilder<UserProfileModel?>(
        stream: BlocProvider.of<ProfileCubit>(context).profile(widget.uid),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: Container(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
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
                if (snapshot.hasData)
                  Text(
                      "${snapshot.data?.firstName} ${snapshot.data?.lastName}"),
                if (snapshot.hasData) Text("@${snapshot.data?.userName}")
              ],
            ),
          );
        },
      ),
    );
  }
}
