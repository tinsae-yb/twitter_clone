import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitter_clone/feeds/cubit/tweet_cubit.dart';
import 'package:twitter_clone/model/tweet_model.dart';

class ReplyTweetScreen extends StatefulWidget {
  final TweetModel tweetModel;
  const ReplyTweetScreen({required this.tweetModel, Key? key})
      : super(key: key);

  @override
  State<ReplyTweetScreen> createState() => _ReplyTweetScreenState();
}

class _ReplyTweetScreenState extends State<ReplyTweetScreen> {
  late TextEditingController tweetTextEditingController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    tweetTextEditingController = TextEditingController();
    formKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<TweetCubit, TweetState>(
      listener: (context, state) {
        if (state is UnAuthorized) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/", (Route route) => route.settings.name == "/");
        } else if (state is TweetReplied) {
          Navigator.pop(context);
        } else if (state is TweetReplyFailed) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Replying tweet failed, Try again"),
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
              if (state is ReplyingTweet)
                const Center(child: CircularProgressIndicator())
              else
                TextButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        BlocProvider.of<TweetCubit>(context).createTweetReply(
                            tweetTextEditingController.text.trim(),
                            widget.tweetModel.id);
                      }
                    },
                    child: const Text(
                      "Reply",
                    ))
            ],
            centerTitle: true,
            title: Text(
              "Reply tweet",
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
                        RichText(
                            text: TextSpan(
                                text: "Reply to tweet: ",
                                style: Theme.of(context).textTheme.bodyText1,
                                children: [
                              TextSpan(
                                  text: widget.tweetModel.tweet,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor))
                            ])),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: tweetTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v?.trim().isEmpty ?? true) {
                              return "reply can't be empty";
                            }

                            return null;
                          },
                          maxLines: 15,
                          decoration: InputDecoration(
                              enabled: state is! ReplyingTweet,
                              border: InputBorder.none,
                              hintText: "Reply",
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
