import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/constants.dart';
import '../../../core/util/alignment_extensions.dart';
import '../../../core/util/spacing_widgets.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import '../widgets/event_entry_bottom_sheet.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);
  static const String id = 'eventsView';

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  EventLogic logic = EventLogic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(context),
      body: SafeArea(
        child: GetBuilder<EventController>(
          builder: (controller) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .doc('events')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  );
                }
                final data = snapshot.data?.data();

                if (data == null) {
                  return SizedBox(
                    height: Get.height,
                    child: const Text(
                      'No events are added',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ).center,
                  );
                }

                Event? event = Event.fromJson(data as Map<String, dynamic>);

                if ((event.eventElement ?? []).isEmpty) {
                  return SizedBox(
                    height: Get.height,
                    child: const Text(
                      'No events are added',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ).center,
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Spacing.h10,
                      ...(event.eventElement ?? []).map(
                        (element) => buildEventCard(
                          element: element,
                          index: (event.eventElement ?? []).indexOf(element),
                        ).paddingOnly(top: 20),
                      ),
                      Spacing.h30,
                    ],
                  ),
                );
              },
            );
          },
        ).paddingSymmetric(horizontal: 20),
      ),
    );
  }

  Widget buildEventCard({required EventElement element, required int index}) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              offset: const Offset(1, 3),
              spreadRadius: 2,
              color: Colors.grey.shade100),
        ],
      ),
      child: Column(
        children: [
          buildContent(title: 'Session Name', value: element.session),
          buildContent(title: 'Location', value: element.location),
          buildContent(
              title: 'Date & Time', value: '${element.date} @ ${element.time}'),
          buildContent(
              title: 'Contact Person',
              value: '${element.employees[0].name} ( ${element.phone} )'),
          Spacing.h15,
          buildDeleteEdit(index: index, eventElement: element),
          Spacing.h15,
          RichText(
            text: TextSpan(
              text: 'Created By : ',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.nunito,
                color: Colors.grey,
              ),
              children: <TextSpan>[
                TextSpan(
                    style: TextStyle(color: AppColors.text.black),
                    text: element.createdBy ?? '-'),
              ],
            ),
          ).left,
        ],
      ).paddingSymmetric(horizontal: 20, vertical: 20),
    );
  }

  Widget buildContent({required String title, required String value}) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.nunito,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.nunito,
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
            ),
          ),
        ),
      ],
    ).paddingOnly(top: 5);
  }

  Widget buildDeleteEdit(
      {required int index, required EventElement eventElement}) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton.miniFlat(
            text: 'Delete',
            onTap: () {
              deleteDialog(context, index: index, eventElement: eventElement);
            },
          ),
          Spacing.w25,
          AppButton.miniFlat(
            text: 'Edit',
            onTap: () {
              EventEntryBottomSheet.show(
                context,
                elementIndex: index,
                eventElementModel: eventElement,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildIcons({required IconData icon, required Function onTap}) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: AppColors.text.lightSkyBlue,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        splashRadius: 20,
        iconSize: 15,
        onPressed: () {
          onTap();
        },
        icon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> deleteDialog(BuildContext context,
      {required int index, required EventElement eventElement}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Text(
            '${eventElement.session} will be completely deleted',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Get.back();
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () {
                logic.onDeletePressed(index);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        EventEntryBottomSheet.show(context);
      },
      backgroundColor: AppColors.background.black,
      child: const Icon(Icons.add),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'Events',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 20,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.normal,
          letterSpacing: 1.0,
        ),
      ),
      leading: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: AppColors.text.black,
          size: 17,
        ),
      ),
      elevation: 0,
      backgroundColor: AppColors.background.white,
    );
  }
}
