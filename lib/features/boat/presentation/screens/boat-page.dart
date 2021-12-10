import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/features/boat/controller/boat-controller.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/customer-registration-screen.dart';

class BoatPage extends StatelessWidget {
  final BoatLogic logic = BoatLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () {
              Get.toNamed(CustomerRegistrationScreen.id);
            },
            child: Text("Under Construction"),
          ),
        ),
      ),
    );
  }
}
