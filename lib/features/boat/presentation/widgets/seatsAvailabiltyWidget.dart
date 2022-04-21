import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/features/boat/models/boat-model.dart';

class SeatsAvailabilityExpansionPanel extends StatefulWidget {
  final int boatID;

  SeatsAvailabilityExpansionPanel(this.boatID);

  @override
  State<SeatsAvailabilityExpansionPanel> createState() =>
      _SeatsAvailabilityExpansionPanelState();
}

class _SeatsAvailabilityExpansionPanelState

    extends State<SeatsAvailabilityExpansionPanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("boats")
            .doc(widget.boatID.toString())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            BoatsModel boat = BoatsModel.fromMap(snapshot.data.data());
            return buildExpansion(boatsModel: boat);
          }
          return Container();
        });
  }

  Widget buildExpansion({BoatsModel boatsModel}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInCubic,
        alignment: Alignment.topCenter,
        height: isExpanded ? 310 : 50,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: AppColors.text.grey),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        child: Text(
                          boatsModel.boatName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: AppColors.text.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        splashRadius: 20,
                        iconSize: 23,
                        icon: Icon(isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded),
                        onPressed: () {
                          setState(() {
                            isExpanded = !isExpanded;
                            log(isExpanded.toString());
                          });
                        },
                      ),
                    ]),
                isExpanded
                    ? FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 200)),
                        initialData: SizedBox(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done)
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 145,
                                      width: 270,
                                      child: Wrap(
                                          direction: Axis.horizontal,
                                          verticalDirection:
                                              VerticalDirection.down,
                                          children: [
                                            ...List.generate((4), (index) {
                                              return buildSeat(
                                                  borderColor:
                                                      AppColors.text.skyBlue,
                                                  color: AppColors
                                                      .text.lightSkyBlue,
                                                  seatNoColor:
                                                      AppColors.text.black,
                                                  seatNo: index + 1);
                                            }),
                                            ...List.generate(
                                                (boatsModel.capacity - 4),
                                                (index) {
                                              return buildSeat(
                                                  borderColor:
                                                      Color(0xff5BFF62),
                                                  color: Color(0xffD1FFBB),
                                                  seatNoColor:
                                                      AppColors.text.grey,
                                                  seatNo: index + 5);
                                            }),
                                          ]),
                                    ),
                                  ],
                                ),
                                buildSeatColorRepresentation(
                                    borderColor: AppColors.text.skyBlue,
                                    color: AppColors.text.lightSkyBlue,
                                    text: "Selected"),
                                SizedBox(height: 15),
                                buildSeatColorRepresentation(
                                    borderColor: Color(0xff5BFF62),
                                    color: Color(0xffD1FFBB),
                                    text: "Available")
                              ],
                            );
                          return SizedBox();
                        })
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSeat(
      {Color borderColor, Color color, int seatNo, Color seatNoColor}) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5, top: 13),
      child: Container(
        height: 22,
        width: 17,
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(4),
            border: Border.all(color: borderColor, width: 1),
            color: color),
        child: Center(
          child: Text(
            seatNo.toString(),
            style: TextStyle(fontSize: 8, color: seatNoColor),
          ),
        ),
      ),
    );
  }

  Widget buildSeatColorRepresentation(
      {Color borderColor, Color color, String text}) {
    return Row(
      children: [
        Container(
          height: 22,
          width: 17,
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(4),
              border: Border.all(color: borderColor, width: 1),
              color: color),
          child: Center(
            child: Icon(Icons.star,
                size: 8,
                color: (text == "Selected")
                    ? AppColors.text.black
                    : AppColors.text.grey),
          ),
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
