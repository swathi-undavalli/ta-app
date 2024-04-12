import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/activity_model.dart';
import '../../controller/all_activities_controller.dart';
import 'activity_edit_view.dart';
import 'add_new_activity_view.dart';

class AllActivitiesView extends StatelessWidget {
  static const String id = 'PriceEditingScreen';
  final AllActivitiesLogic logic = AllActivitiesLogic();

  AllActivitiesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background.lightBlue,
          floatingActionButton: buildFloatingActionButton(),
          appBar: const AppBarWidget(heading: 'All Activities'),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: GetBuilder<AllActivitiesController>(
                  builder: (controller) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        for (int i = 0; i < controller.allActivitiesList.length; i++)
                          buildActivities(controller.allActivitiesList[i]),
                        const SizedBox(height: 50),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        buildShowLoading(),
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
          Get.toNamed(AddNewActivityView.id);
        },
        backgroundColor: AppColors.background.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildShowLoading() {
    return GetBuilder<AllActivitiesController>(
      builder: (controller) {
        if (controller.showLoading) {
          return Container(
            color: Colors.black54,
            height: Get.height,
            width: Get.width,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildActivities(Activity activityModel) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(ActivityEditView.id, arguments: activityModel);
      },
      child: SizedBox(
        height: 50,
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  width: Get.width,
                  child: Text(
                    activityModel.name!,
                    style: TextStyle(
                      color: AppColors.text.black,
                      fontSize: FontSize.small,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: 100,
                child: Text(
                  '${activityModel.price} /-',
                  style: TextStyle(
                    color: AppColors.text.black,
                    fontSize: FontSize.textSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
