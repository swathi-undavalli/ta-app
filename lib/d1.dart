import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:temple_adventures/core/constants/assets.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/util/ta-image.dart';

class Dummy extends StatelessWidget {
  static const String id = "Dummy";
  DateTime date = DateTime.now();
  List<double> payments = [
    10000,
    7000,
    7000,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildPaymentStatus(
              totalAmount: "100000",
              payments: payments,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentStatus({String totalAmount, List<double> payments}) {
    var list = payments;
    var total = totalAmount;
    double deposits = 0.0;
    list.forEach((element) {
      deposits += element;
    });
    int n = list.length;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildMessageBox(),
              buildMessageBox(),
              buildMessageBox(),
            ],
          ).paddingOnly(left: 20, bottom: 10),
          Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: (120 * (payments.length + 1) * 1.0),
                    height: 1,
                    color: (double.parse(total) == deposits)
                        ? Colors.green.shade400
                        : Colors.black,
                  ),
                ],
              ).paddingOnly(top: 7, left: 56),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(n, (i) {
                    return buildCircle(color: Colors.black);
                  }),
                ),
                (double.parse(total) == deposits)
                    ? SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildCircle(color: Colors.red.shade300),
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                            color: AppColors.text.skyBlue,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.circle,
                          size: 10,
                          color: AppColors.text.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List<Widget>.generate(n, (i) {
                      return buildNumber(
                          text: list[i].round().toString(),
                          fontWeight: FontWeight.normal,
                          color: Colors.black);
                    }),
                  ),
                  (double.parse(total) == deposits)
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildNumber(
                                text: (double.parse(total) - deposits)
                                    .round()
                                    .toString(),
                                // text: "16000",
                                color: Colors.red.shade300,
                                fontWeight: FontWeight.normal),
                          ],
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildNumber(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        text: totalAmount,
                      ),
                    ],
                  ),
                ],
              ).paddingOnly(top: 20),
            ],
          ).paddingOnly(left: 10, right: 10),
        ],
      ),
    );
  }

  Widget buildMessageBox() {
    return Stack(
      children: [
        Container(
          height: 80,
          child: Center(
            child: Container(
              child: TAImage(AppImages.icon.messageBox),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x19000000).withOpacity(0.04),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ).paddingOnly(right: 15, left: 5),
          ).paddingOnly(top: 10),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Paid to :  Donarun Das",
                style: TextStyle(fontSize: 7),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Date :  ",
                    style: TextStyle(fontSize: 7),
                  ),
                  Text(
                    DateFormat("MMM - dd - yyyy").format(date),
                    style: TextStyle(fontSize: 7),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Time :  ",
                    style: TextStyle(fontSize: 7),
                  ),
                  Text(
                    DateFormat("hh:mm a").format(date),
                    style: TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCircle({Color color}) {
    return SizedBox(
      width: 120,
      child: Icon(
        Icons.circle,
        size: 10,
        color: color,
      ),
    );
  }

  Widget buildNumber({FontWeight fontWeight, Color color, String text}) {
    return SizedBox(
      width: 120,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 10, fontWeight: fontWeight, color: color),
        ),
      ),
    );
  }
}
