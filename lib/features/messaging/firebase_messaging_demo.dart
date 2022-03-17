import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:temple_adventures/features/messaging/firebase_messaging_controller.dart';

class FirebaseMessagingDemo extends StatelessWidget {
  FirebaseMessagingDemo({Key key}) : super(key: key);

  static const String id = "/FirebaseMessagingDemo";

  final FirebaseMessagingLogic logic = FirebaseMessagingLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Messaging Demo"),
      ),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
