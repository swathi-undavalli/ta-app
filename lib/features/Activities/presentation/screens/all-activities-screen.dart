import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/features/Activities/controller/all-activities-controller.dart';
import 'package:temple_adventures/features/Activities/presentation/screens/activity-edit-screen.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';

class AllActivitiesScreen extends StatelessWidget {
  static const String id = "PriceEditingScreen";
  AllActivitiesLogic logic = AllActivitiesLogic();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            elevation: 0,
            onPressed: () {},
            backgroundColor: AppColors.background.black,
            child: Icon(Icons.add),
          ),
          appBar: buildAppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child:
                    GetBuilder<AllActivitiesController>(builder: (controller) {
                  return Column(
                    children: [
                      for (int i = 0;
                          i < controller.allActivitiesList.length;
                          i++)
                        buildActivities(controller.allActivitiesList[i]),
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

  ///============UI=============///

  Widget buildShowLoading() {
    return GetBuilder<AllActivitiesController>(builder: (controller) {
      if (controller.showLoading)
        return Container(
          color: Colors.black54,
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

  Widget buildActivities(ActivityModel activityModel) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(ActivityEditScreen.id, arguments: activityModel);
      },
      child: Container(
        height: 50,
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: Get.width,
                  child: Text(
                    activityModel.name,
                    style: TextStyle(
                        color: AppColors.text.black,
                        fontSize: FontSize.small,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 100,
                child: Text(
                  activityModel.price.toString() + " /-",
                  style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: FontSize.textSize,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: buildTitle(),
      leading: BackNavigationIcon(),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }

  Widget buildTitle() {
    return Text(
      'All Activities',
      style: TextStyle(
        color: AppColors.text.black,
        fontSize: 20,
        fontFamily: AppFonts.nunito,
        fontWeight: FontWeight.normal,
        letterSpacing: 1.2,
      ),
    );
  }
}
