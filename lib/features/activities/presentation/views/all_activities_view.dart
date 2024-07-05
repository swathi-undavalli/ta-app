import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../bookings/models/activity_model.dart';
import 'add_new_activity_view.dart';

class AllActivitiesView extends StatefulWidget {
  const AllActivitiesView({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(
        builder: (context) => const AllActivitiesView(),
      );

  @override
  State<AllActivitiesView> createState() => _AllActivitiesViewState();
}

class _AllActivitiesViewState extends State<AllActivitiesView> {
  List<Activity> allActivitiesList = [];

  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.background.lightBlue,
          floatingActionButton: buildFloatingActionButton(),
          appBar: const AppBarWidget(heading: 'All Activities'),
          body: SafeArea(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('catalogue').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError || snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  );
                }

                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return SizedBox(
                    height: Screen.height,
                    child: const Text(
                      'No activities added',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ).center,
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Spacing.h20,
                          ...snapshot.data!.docs.map((DocumentSnapshot document) {
                            try {
                              Activity? activity = Activity.fromMap(
                                document.data() as Map<String, dynamic>,
                              );
                              return buildActivity(
                                activityModel: activity,
                              );
                            } catch (e) {
                              return const SizedBox();
                            }
                          }).toList(),
                          Spacing.h100,
                        ],
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 20);
              },
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
          Navigator.push(context, AddNewActivityView.route(null));
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
    if (showLoading) {
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
      return const SizedBox();
    }
  }

  Widget buildActivity({required Activity activityModel}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, AddNewActivityView.route(activityModel));
      },
      child: SizedBox(
        height: 50,
        width: Screen.width,
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
    );
  }
}
