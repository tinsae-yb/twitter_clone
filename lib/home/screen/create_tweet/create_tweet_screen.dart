import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/home/screen/create_tweet/cubit/create_tweet_cubit.dart';

class CreateTweetScreen extends StatefulWidget {
  const CreateTweetScreen({Key? key}) : super(key: key);

  @override
  State<CreateTweetScreen> createState() => _CreateTweetScreenState();
}

class _CreateTweetScreenState extends State<CreateTweetScreen> {
  late TextEditingController tweetTextEditingController;
  late GlobalKey<FormState> formKey;
  XFile? xFile;

  @override
  void initState() {
    tweetTextEditingController = TextEditingController();
    formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<CreateTweetCubit, CreateTweetState>(
      listener: (context, state) {
        if (state is UnAuthorized) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/", (Route route) => route.settings.name == "/");
        } else if (state is TweetCreated) {
          Navigator.pop(context);
        } else if (state is CreatingTweetFailed) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Creating tweet failed, Try again"),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            actions: [
              if (state is CreatingTweet)
                const Center(child: CircularProgressIndicator())
              else
                TextButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        BlocProvider.of<CreateTweetCubit>(context).createTweet(
                            tweetTextEditingController.text.trim(),
                            xFile?.path);
                      }
                    },
                    child: const Text(
                      "Tweet",
                    ))
            ],
            centerTitle: true,
            title: Text(
              "Create tweet",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: size.width * 0.8,
                child: Form(
                    key: formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: tweetTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v?.trim().isEmpty ?? true) {
                              return "tweet can't be empty";
                            }

                            return null;
                          },
                          maxLines: 15,
                          decoration: InputDecoration(
                              enabled: state is! CreatingTweet,
                              border: InputBorder.none,
                              hintText: "What's going on?",
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
                        if (xFile != null)
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                File(xFile?.path ?? ""),
                                height: size.height * 0.25,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle),
                                child: IconButton(
                                    onPressed: state is CreatingTweet
                                        ? null
                                        : () {
                                            xFile = null;
                                            setState(() {});
                                          },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    )),
                              )
                            ],
                          ),
                        if (xFile == null)
                          TextButton.icon(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: state is CreatingTweet
                                  ? null
                                  : () async {
                                      bool? fromCamera = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            "Add pic",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6,
                                          ),
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.camera),
                                                    Text(
                                                      "Camera",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.image),
                                                    Text(
                                                      "Gallery",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );

                                      if (fromCamera != null) {
                                        xFile = await BlocProvider.of<
                                                CreateTweetCubit>(context)
                                            .pickImage(fromCamera);
                                        setState(() {});
                                      }
                                    },
                              label: const Text(
                                "Add pic",
                              )),
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
