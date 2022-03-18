import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/auth/auth.dart';
import 'package:twitter_clone/auth/cubit/auth_cubit.dart';
import 'package:twitter_clone/auth/repository/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter_clone/home/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
              builder: (context) => const HomeScreen(),
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
