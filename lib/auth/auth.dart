import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/auth/cubit/auth_cubit.dart';
import 'package:twitter_clone/auth/screens/unauthenticated.dart';
import 'package:twitter_clone/home/screen/home_screen.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, "/home");
          }
        },
        builder: (context, state) {
          if (state is UnAuthenticated) return const UnAuthenticatedScreen();
          return Container();
        },
        buildWhen: (previous, current) => current is UnAuthenticated,
      ),
    );
  }
}
