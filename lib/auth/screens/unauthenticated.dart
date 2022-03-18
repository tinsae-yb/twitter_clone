import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/auth/cubit/auth_cubit.dart';

class UnAuthenticatedScreen extends StatefulWidget {
  const UnAuthenticatedScreen({Key? key}) : super(key: key);

  @override
  State<UnAuthenticatedScreen> createState() => _UnAuthenticatedScreenState();
}

class _UnAuthenticatedScreenState extends State<UnAuthenticatedScreen> {
  late TextEditingController emailTextEditingController;
  late TextEditingController passwordTextEditingController;
  late GlobalKey<FormState> formKey;
  @override
  initState() {
    emailTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  bool signup = false;
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatingFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: size.width * 0.8,
                child: Form(
                    key: formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            signup ? "Sign up" : "Sign In",
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v?.isEmpty ?? true) return "Enter your email";
                            if (v != null &&
                                !BlocProvider.of<AuthCubit>(context)
                                    .emailRegEx
                                    .hasMatch(v.trim())) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              enabled: state is! Authenticating,
                              label: const Text("Email"),
                              labelStyle: Theme.of(context)
                                  .inputDecorationTheme
                                  .labelStyle,
                              fillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              filled: true),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (v) {
                            if (v?.isEmpty ?? true) {
                              return "Enter your password";
                            }
                            if (v != null && v.trim().length < 8) {
                              return "Password length should be at least 8 characters";
                            }
                            return null;
                          },
                          controller: passwordTextEditingController,
                          obscureText: obscurePassword,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    obscurePassword = !obscurePassword;
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.remove_red_eye)),
                              enabled: state is! Authenticating,
                              label: const Text("password"),
                              labelStyle: Theme.of(context)
                                  .inputDecorationTheme
                                  .labelStyle,
                              fillColor: Theme.of(context)
                                  .inputDecorationTheme
                                  .fillColor,
                              filled: true),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: state is Authenticating
                                ? null
                                : () {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      if (signup) {
                                        BlocProvider.of<AuthCubit>(context)
                                            .signUp(
                                                emailTextEditingController.text
                                                    .trim(),
                                                passwordTextEditingController
                                                    .text
                                                    .trim());
                                      } else {
                                        BlocProvider.of<AuthCubit>(context)
                                            .signIn(
                                                emailTextEditingController.text
                                                    .trim(),
                                                passwordTextEditingController
                                                    .text
                                                    .trim());
                                      }
                                    }
                                  },
                            child: Text(
                              signup ? "Sign up" : "Sign In",
                            )),
                        if (state is Authenticating)
                          const LinearProgressIndicator(),
                        TextButton(
                            onPressed: state is Authenticating
                                ? null
                                : () {
                                    signup = !signup;
                                    setState(() {});
                                  },
                            child: Text(signup
                                ? "already have an account"
                                : "Don't have an account?"))
                      ],
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}
