import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/profile/cubit/profile_cubit.dart';

class FollowUnfollowComponent extends StatefulWidget {
  final String uid;
  const FollowUnfollowComponent({required this.uid, Key? key})
      : super(key: key);

  @override
  State<FollowUnfollowComponent> createState() =>
      _FollowUnfollowComponentState();
}

class _FollowUnfollowComponentState extends State<FollowUnfollowComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<Map<String, dynamic>?>(
          stream:
              BlocProvider.of<ProfileCubit>(context).followStatus(widget.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data == null ||
                  (snapshot.data != null && !snapshot.data?["following"])) {
                return TextButton(
                    onPressed: () {
                      BlocProvider.of<ProfileCubit>(context)
                          .toggleFollowUnfollow(widget.uid, true);
                    },
                    child: const Text("Follow"));
              }
              if ((snapshot.data != null && snapshot.data?["following"])) {
                return TextButton(
                    onPressed: () {
                      BlocProvider.of<ProfileCubit>(context)
                          .toggleFollowUnfollow(widget.uid, false);
                    },
                    child: const Text("UnFollow"));
              }
            }
            return Container();
          },
        ),
        TextButton(onPressed: () {}, child: const Text("Message"))
      ],
    );
  }
}
