import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/activity_model.dart';
import '../../controller/all_activities_controller.dart';
import 'activity_edit_view.dart';
import 'add_new_activity_view.dart';

class AllActivitiesView extends StatelessWidget {
  final AllActivitiesLogic logic = AllActivitiesLogic();

  AllActivitiesView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => AllActivitiesView(),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background.lightBlue,
          floatingActionButton: buildFloatingActionButton(context),
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
                          buildActivities(context, controller.allActivitiesList[i]),
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

  Widget buildFloatingActionButton(BuildContext context) {
    return EmployeeAccess(
      access: AccessRights.addActivity,
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          Navigator.push(context, AddNewActivityView.route());
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
            height: Screen.height,
            width: Screen.width,
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

  Widget buildActivities(BuildContext context, Activity activityModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, ActivityEditView.route(activityModel));
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
                  width: Screen.width,
                  child: Text(
                    '${activityModel.id} - ${activityModel.name!}',
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
