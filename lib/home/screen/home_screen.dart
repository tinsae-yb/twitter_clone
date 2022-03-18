import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/home/cubit/home_cubit.dart';
import 'package:twitter_clone/home/screen/components/your_profile_doesnt_exist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
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

              return Container();
            },
          ),
        );
      },
      buildWhen: (previous, current) =>
          current is CheckingIfProfileExists ||
          (previous is CheckingIfProfileExists &&
              current is ProfileCheckResult),
    );
  }
}
