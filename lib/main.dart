import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/auth/auth.dart';
import 'package:twitter_clone/auth/cubit/auth_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter_clone/home/cubit/home_cubit.dart';
import 'package:twitter_clone/home/screen/home_screen.dart';
import 'package:twitter_clone/repository/auth_repository.dart';
import 'package:twitter_clone/repository/image_repository.dart';
import 'package:twitter_clone/repository/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(
              builder: (context) => BlocProvider<AuthCubit>(
                  create: (context) => AuthCubit(AuthRepository()),
                  child: const Auth()),
            );

          default:
        }
        switch (settings.name) {
          case "/home":
            return MaterialPageRoute(
              builder: (context) => BlocProvider<HomeCubit>(
                create: (context) => HomeCubit(
                    imageRepository: ImageRepository(),
                    profileRepository: ProfileRepository(),
                    authRepository: AuthRepository()),
                child: const HomeScreen(),
              ),
            );

          default:
        }
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
