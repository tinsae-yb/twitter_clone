import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/landing_screen/cubit/home_cubit.dart';

class YourProfileDoesntExist extends StatefulWidget {
  const YourProfileDoesntExist({Key? key}) : super(key: key);

  @override
  State<YourProfileDoesntExist> createState() => _YourProfileDoesntExistState();
}

class _YourProfileDoesntExistState extends State<YourProfileDoesntExist> {
  late TextEditingController firstNameTextEditingController;
  late TextEditingController lastNameTextEditingController;
  late TextEditingController userNameTextEditingController;
  late GlobalKey<FormState> formKey;
  XFile? xFile;
  @override
  initState() {
    firstNameTextEditingController = TextEditingController();
    lastNameTextEditingController = TextEditingController();
    userNameTextEditingController = TextEditingController();
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is CreatingProfileFailed) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Creating profile failed, Try again"),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      builder: (context, state) {
        return SafeArea(
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
                          "Finish creating your profile",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: firstNameTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v?.trim().isEmpty ?? true)
                            return "Enter first name";

                          return null;
                        },
                        decoration: InputDecoration(
                            enabled: state is! CreatingProfile,
                            label: const Text("First name"),
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
                          if (v?.trim().isEmpty ?? true) {
                            return "Enter last name";
                          }

                          return null;
                        },
                        controller: lastNameTextEditingController,
                        decoration: InputDecoration(
                            enabled: state is! CreatingProfile,
                            label: const Text("Last name"),
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
                          if (v?.trim().isEmpty ?? true) {
                            return "Enter username";
                          }

                          return null;
                        },
                        controller: userNameTextEditingController,
                        decoration: InputDecoration(
                            enabled: state is! CreatingProfile,
                            label: const Text("Username"),
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
                                  onPressed: state is CreatingProfile?null:  () {
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
                            onPressed: state is CreatingProfile
                                ? null
                                : () async {
                                    bool? fromCamera = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "Add profile pic",
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
                                                mainAxisSize: MainAxisSize.min,
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
                                                mainAxisSize: MainAxisSize.min,
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
                                      xFile = await BlocProvider.of<HomeCubit>(
                                              context)
                                          .pickImage(fromCamera);
                                      setState(() {});
                                    }
                                  },
                            label: const Text(
                              "Add profile pic",
                            )),
                      const Divider(),
                      ElevatedButton(
                          onPressed: state is CreatingProfile
                              ? null
                              : () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    BlocProvider.of<HomeCubit>(context)
                                        .finishCreatingProfile(
                                            firstNameTextEditingController.text
                                                .trim(),
                                            lastNameTextEditingController.text
                                                .trim(),
                                            userNameTextEditingController.text
                                                .trim(),
                                            xFile?.path);
                                  }
                                },
                          child: const Text(
                            "Create profile",
                          )),
                      if (state is CreatingProfile)
                        const LinearProgressIndicator(),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
