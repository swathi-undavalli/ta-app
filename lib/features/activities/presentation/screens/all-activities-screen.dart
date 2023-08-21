import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_adventures/core/constants/constants.dart';
import 'package:temple_adventures/core/widgets/back-navigation-icon.dart';
import 'package:temple_adventures/core/widgets/access_levels.dart';
import 'package:temple_adventures/features/bookings/models/activity-model.dart';

import '../../controller/all-activities-controller.dart';
import 'activity-edit-screen.dart';
import 'add-new-activity-screen.dart';

class AllActivitiesScreen extends StatelessWidget {
  static const String id = "PriceEditingScreen";
  final AllActivitiesLogic logic = AllActivitiesLogic();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: buildFloatingActionButton(),
          appBar: buildAppBar() as PreferredSizeWidget?,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Center(
                child:
                    GetBuilder<AllActivitiesController>(builder: (controller) {
                  return Column(
                    children: [
                      SizedBox(height: 20),
                      for (int i = 0;
                          i < controller.allActivitiesList.length;
                          i++)
                        buildActivities(controller.allActivitiesList[i]),
                      SizedBox(height: 50),
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

  Widget buildFloatingActionButton() {
    return EmployeeAccess(
      access: AccessRights.addActivity,
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Get.toNamed(AddNewActivityScreen.id);
        },
        backgroundColor: AppColors.background.black,
        child: Icon(Icons.add),
      ),
    );
  }

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

  Widget buildActivities(Activity activityModel) {
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
                    activityModel.name!,
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
