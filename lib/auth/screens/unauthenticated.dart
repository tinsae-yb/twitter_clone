import 'package:flutter/material.dart';

class UnAuthenticatedScreen extends StatefulWidget {
  const UnAuthenticatedScreen({Key? key}) : super(key: key);

  @override
  State<UnAuthenticatedScreen> createState() => _UnAuthenticatedScreenState();
}

class _UnAuthenticatedScreenState extends State<UnAuthenticatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("UnAuthenticated"),
      ),
    );
  }
}
