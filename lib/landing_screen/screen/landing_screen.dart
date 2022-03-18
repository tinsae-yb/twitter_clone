import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/feeds/feeds_screen.dart';
import 'package:twitter_clone/landing_screen/cubit/home_cubit.dart';
import 'package:twitter_clone/landing_screen/screen/components/your_profile_doesnt_exist.dart';
import 'package:twitter_clone/message/messages_screen.dart';
import 'package:twitter_clone/search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController pageViewController;
  late List<Widget> widgets;
  // const GlobalKey feedScreenGlobalKey = GlobalKey(debugLabel: "feeds");
  @override
  void initState() {
    widgets = [
      const FeedsScreen(),
      const SearchScreen(),
      const MessagesScreen()
    ];
    pageViewController = PageController(initialPage: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      BlocProvider.of<HomeCubit>(context).checkUserProfileExists();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is UnAuthorized) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/", (Route route) => route.settings.name == "/");
        } else if (state is ProfileCreated) {
          BlocProvider.of<HomeCubit>(context).checkUserProfileExists();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (state is CheckingIfProfileExists) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is ProfileCheckResult && !state.profileExist) {
                return const YourProfileDoesntExist();
              }
              if (state is ProfileCheckResult && state.profileExist) {
                return PageView(
                  onPageChanged: (value) {
                    setState(() {});
                  },
                  controller: pageViewController,
                  children: const [
                    FeedsScreen(),
                    SearchScreen(),
                    MessagesScreen()
                  ],
                );
              }
              if (state is CheckingProfileExistenceFailed) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Internet connection problem"),
                      TextButton(
                          onPressed: () {
                            BlocProvider.of<HomeCubit>(context)
                                .checkUserProfileExists();
                          },
                          child: const Text("Refresh"))
                    ],
                  ),
                );
              }

              return Container();
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (i) async {
                await pageViewController.animateToPage(i,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn);
              },
              currentIndex: pageViewController.hasClients
                  ? pageViewController.page?.round() ?? 0
                  : 0,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), tooltip: "Home", label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    tooltip: "Search",
                    label: "Search"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.message),
                    tooltip: "Message",
                    label: "Message"),
              ]),
          floatingActionButton: state is CheckingIfProfileExists ||
                  state is CheckingProfileExistenceFailed
              ? null
              : FloatingActionButton(
                  onPressed: () => Navigator.pushNamed(context, "/createTweet"),
                  child: const Icon(Icons.add),
                ),
        );
      },
      buildWhen: (previous, current) =>
          current is CheckingIfProfileExists ||
          current is CheckingProfileExistenceFailed ||
          (previous is CheckingIfProfileExists &&
              current is ProfileCheckResult),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
