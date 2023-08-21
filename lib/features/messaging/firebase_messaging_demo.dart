import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:temple_adventures/core/util/utils.dart';
import 'package:temple_adventures/features/messaging/firebase_messaging_controller.dart';

class FirebaseMessagingDemo extends StatelessWidget {
  FirebaseMessagingDemo({Key? key}) : super(key: key);

  static const String id = "/FirebaseMessagingDemo";

  final FirebaseMessagingLogic logic = FirebaseMessagingLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Messaging Demo"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      FirebaseMessaging.instance
                          .subscribeToTopic("newBooking")
                          .whenComplete(() => showToast("Subscribed"));
                    },
                    child: Text("Subscribe"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseMessaging.instance
                          .unsubscribeFromTopic("newBooking")
                          .whenComplete(() => showToast("UnSubscribed"));
                    },
                    child: Text("UnSubscribe"),
                  ),
                ],
              ),
              // Spacer(),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("bookings")
                      .doc("106")
                      .set({
                    "id": "106",
                    "employeeName": "sahitha",
                    "activity": [
                      {
                        "name": "Discover Scuba Diving",
                      }
                    ]
                  });
                },
                child: Text("DO"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
