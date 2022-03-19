import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:twitter_clone/landing_screen/cubit/landing_cubit.dart';
import 'package:twitter_clone/model/user_profile_model.dart';

class LandingDrawer extends StatefulWidget {
  const LandingDrawer({Key? key}) : super(key: key);

  @override
  State<LandingDrawer> createState() => _LandingDrawerState();
}

class _LandingDrawerState extends State<LandingDrawer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          drawerHeader(context, size),
          SizedBox(
            width: size.width,
            child: TextButton.icon(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () {},
                icon: const Icon(Icons.person),
                label: const Text("Profile")),
          ),
          Divider(),
          SizedBox(
            width: size.width,
            child: TextButton.icon(
                style: const ButtonStyle(alignment: Alignment.centerLeft),
                onPressed: () async {
                  await BlocProvider.of<LandingCubit>(context).signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      "/", (Route route) => route.settings.name == "/");
                },
                icon: const Icon(Icons.logout),
                label: const Text("Sign out")),
          )
        ],
      ),
    );
  }

  DrawerHeader drawerHeader(BuildContext context, Size size) {
    return DrawerHeader(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<UserProfileModel>(
          stream: BlocProvider.of<LandingCubit>(context).myProfileSnapshot(),
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
      ],
    ));
  }
}
