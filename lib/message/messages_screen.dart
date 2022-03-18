import 'dart:developer';

import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  void initState() {
    log("messages screen init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Messages"),
    );
  }
}
