import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/boat/presentation/widgets/seatsAvailabiltyWidget.dart';

class ChooseBoatPage extends StatelessWidget {
  static const String id = "ChooseBoatPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          // Get.toNamed(ChooseBoatPage.id);
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                buildSeatsSelected(),
                SizedBox(height: 40),
                ...List.generate(4, (index) {
                  log(index.toString());
                  return SeatsAvailabilityExpansionPanel(index + 1);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSeatsSelected() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '4',
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.black,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: '/6',
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: AppFonts.nunito,
                      color: AppColors.text.black,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            alignment: Alignment.bottomCenter,
            height: 27,
            child: Text(
              "Selected",
              style: TextStyle(
                color: AppColors.text.skyBlue,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        "Select Seats",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
