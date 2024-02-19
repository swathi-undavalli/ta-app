import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/ta_image.dart';
import '../../controllers/offers_controller.dart';
import '../../models/category.dart';
import '../../models/offer.dart';
import '../widgets/view_images_bottomsheet.dart';
import 'add_offers_view.dart';

class OffersView extends StatefulWidget {
  const OffersView({Key? key}) : super(key: key);

  static String id = 'OffersView';

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  OffersLogic logic = OffersLogic();

  bool showActiveOffersOnly = false;
  bool showAll = true;

  // bool showValidOnly = false;

  @override
  void initState() {
    super.initState();
    logic.fetchDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('allOffers').doc('offers').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            final data = snapshot.data?.data();

            if (data == null) {
              return SizedBox(
                height: Get.height,
                child: const Text(
                  'No offers added',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ).center,
              );
            }

            Offer? offer = Offer.fromJson(data as Map<String, dynamic>);

            if ((offer.offerElement ?? []).isEmpty) {
              return SizedBox(
                height: Get.height,
                child: const Text(
                  'No offers added',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ).center,
              );
            }
            return SingleChildScrollView(
              child: GetBuilder<OfferController>(
                builder: (controller) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Show Active Offers only'),
                          Switch(
                            value: showActiveOffersOnly,
                            onChanged: (value) {
                              setState(() {
                                showActiveOffersOnly = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Show All'),
                          Switch(
                            value: showAll,
                            onChanged: (value) {
                              setState(() {
                                showAll = value;
                              });
                            },
                          ),
                        ],
                      ),
                      if (showAll == false && showActiveOffersOnly == false)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(color: Colors.black54, width: 1),
                          ),
                          child: const Text(
                            'Showing expired offers',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ).paddingAll(8).center,
                        ).paddingOnly(top: 16),
                      ...(offer.offerElement ?? []).map(
                            (element) {
                          return buildOfferCard(
                            element: element,
                            index: (offer.offerElement ?? []).indexOf(element),
                          ).paddingOnly(top: 20);
                        },
                      ),
                      Spacing.h100,
                    ],
                  ).paddingSymmetric(horizontal: 20);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  bool isDateInRange(DateTime date, DateTime startDate, DateTime endDate) {
    return (date.isAfter(startDate) && date.isBefore(endDate)) ||
        date.isAtSameMomentAs(startDate) ||
        date.isAtSameMomentAs(endDate);
  }

  bool isInFuture(DateTime date, DateTime startDate) {
    return (startDate.isAfter(date) || date.isAtSameMomentAs(startDate));
  }

  bool isInPast(DateTime date, DateTime startDate) {
    return startDate.isBefore(date);
  }

  Widget buildShowLoading() {
    return GetBuilder<OfferController>(
      builder: (controller) {
        if (controller.showLoading) {
          return Material(
            color: Colors.transparent,
            child: Container(
              color: Colors.black54,
              height: Get.height,
              width: Get.width,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      title: Text(
        'All Offers',
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

  Widget buildOfferCard({required OfferElement element, required int index}) {
    DateTime? startDate;
    DateTime? endDate;
    String? categoryName;

    bool showItem = false;

    if (element.validDates?.length == 2) {
      startDate = element.validDates?.first.toDate();
      endDate = element.validDates?.last.toDate();
    }

    if (startDate != null && endDate != null) {
      if (showActiveOffersOnly) {
        if (isInFuture(DateTime.now(), startDate) || isDateInRange(DateTime.now(), startDate, endDate)) {
          showItem = true;
        } else {
          showItem = false;
        }
      } else {
        if (isInPast(DateTime.now(), endDate)) {
          showItem = true;
        }
      }
    }

    if (showAll) {
      showItem = true;
    }

    if (showItem) {
      return Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(offset: const Offset(1, 3), spreadRadius: 2, color: Colors.grey.shade100),
          ],
        ),
        child: GetBuilder<OfferController>(
          builder: (controller) {
            for (Categories cat in logic.controller.categories) {
              if (cat.id == element.categoryId) {
                categoryName = cat.name;
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (element.photos != null && element.photos!.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      ViewPhotosBottomSheet.getImages(
                        context,
                        allImages: element.photos,
                        offer: element.name,
                      );
                    },
                    child: Stack(
                      children: [
                        TAImage(
                          element.photos!.first,
                          width: Get.width,
                          height: 150,
                          fit: BoxFit.cover,
                          borderRadius: 5,
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: Text(
                              element.photos!.length.toString(),
                              style: const TextStyle(color: Colors.black, fontSize: 12),
                            ).center,
                          ),
                        )
                      ],
                    ),
                  ),
                Spacing.h15,
                Text(
                  element.name,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Text(
                  categoryName ?? '-',
                  style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.75)),
                ),
                if (startDate != null && endDate != null)
                  buildContent(
                    title: 'Valid Until',
                    value:
                        '${DateFormat("dd/MM/yyyy").format(startDate)} - ${DateFormat("dd/MM/yyyy").format(endDate)}',
                  ),
                Spacing.h10,
                Text(
                  element.description ?? '--',
                  style: TextStyle(fontSize: 13, color: Colors.black.withOpacity(0.5)),
                ),
                Row(
                  children: [
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
                            text: element.createdBy ?? '-',
                          ),
                        ],
                      ),
                    ).left,
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        logic.onEditPressed(index, element);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteDialog(context, index: index, offerElement: element);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            );
          },
        ).paddingSymmetric(horizontal: 10, vertical: 10),
      );
    }
    return const SizedBox();
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

  Future<void> deleteDialog(BuildContext context, {required int index, required OfferElement offerElement}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Text(
            '${offerElement.name} will be completely deleted',
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

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () {
        Get.toNamed(AddOffersView.id, arguments: null);
      },
      backgroundColor: AppColors.background.black,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
