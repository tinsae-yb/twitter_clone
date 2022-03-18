import 'dart:developer';

import 'package:flutter/material.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  void initState() {
    log("feeds screen init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Feeds"),
    );
  }
}
