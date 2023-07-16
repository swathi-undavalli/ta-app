import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/bookings/controller/idProof-controller.dart';
import 'package:temple_adventures/features/bookings/models/booking-model.dart';
import 'package:temple_adventures/features/bookings/presentation/screens/all-idProofs-screen.dart';

// ignore: must_be_immutable
class IDProofScreen extends StatelessWidget {
  static const String id = "IDProofScreen";
  BookingModel? bookingArg = Get.arguments;
  IDProofLogic logic = IDProofLogic();

  @override
  Widget build(BuildContext context) {
    logic.bookingModel = bookingArg;
    logic.controller.idProofs = bookingArg!.idProofs;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background.lightBlue,
          appBar: buildAppBar() as PreferredSizeWidget?,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: GetBuilder<IDProofController>(builder: (controller) {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300,
                            child: Wrap(
                              spacing: 28,
                              runSpacing: 20,
                              children: [
                                buildAddID(),
                                ...controller.idProofs!.map((e) {
                                  // //log(controller.pickedIDProofs.toString());
                                  return buildIDProofs(image: e);
                                })
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
        buildShowLoading()
      ],
    );
  }

  Widget buildAddID() {
    return GestureDetector(
      onTap: () {
        logic.showBottomSheet(true);
        //log(bookingArg.id);
      },
      child: Container(
        height: 110,
        width: 80,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 15,
              offset: Offset(4, 4),
            ),
          ],
          color: AppColors.text.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(
          Icons.add,
          size: 22,
          color: AppColors.text.black.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget buildIDProofs({String? image}) {
    return GetBuilder<IDProofController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          Get.toNamed(AllIDProofsScreen.id,
              arguments: controller.idProofs!.indexOf(image));
          //print(controller.idProofs.indexOf(image));
        },
        child: Container(
          height: 110,
          width: 80,
          decoration: BoxDecoration(
            image: image != null
                ? DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 15,
                offset: Offset(4, 4),
              ),
            ],
            color: AppColors.text.white,
            borderRadius: BorderRadius.circular(15),
          ),
          // child: TAImage(image.toString(), fit: BoxFit.cover),
        ),
      );
    });
  }

  Widget buildShowLoading() {
    return GetBuilder<IDProofController>(builder: (controller) {
      if (controller.showLoading)
        return Container(
          color: Colors.black38,
          height: Get.height,
          width: Get.width,
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
        );
      else
        return Container();
    });
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        "Manage ID Proofs",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          letterSpacing: 1.2,
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          logic.controller.reset();
        },
        child: BackNavigationIcon(),
      ),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
