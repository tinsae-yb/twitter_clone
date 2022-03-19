import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/profile/component/follow_unfollow_component.dart';
import 'package:twitter_clone/profile/component/profile_screen_header.dart';
import 'package:twitter_clone/profile/cubit/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({this.uid, Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                ProfileScreenHeader(uid: widget.uid),
                if (!(BlocProvider.of<ProfileCubit>(context)
                            .isMyProfile(widget.uid) ??
                        false) &&
                    widget.uid != null)
                  FollowUnfollowComponent(uid: widget.uid as String)
              ],
            )
          ],
        ),
      ),
    );
  }
}
