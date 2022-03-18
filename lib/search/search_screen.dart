import 'dart:developer';

import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key }) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    log("search screen init");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Search"),
    );
  }
}