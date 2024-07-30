import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/firebase/api.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/ta_image.dart';
import '../../models/category.dart';
import '../../models/offer.dart';
import '../widgets/view_images_bottomsheet.dart';
import 'add_offers_view.dart';

class OffersView extends StatefulWidget {
  const OffersView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const OffersView(),
      );

  @override
  State<OffersView> createState() => _OffersViewState();
}

class _OffersViewState extends State<OffersView> {
  bool showActiveOffersOnly = false;
  bool showAll = true;

  bool showLoading = false;
  List<Categories> newCategories = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: const AppBarWidget(heading: 'All Offers'),
      floatingActionButton: buildFloatingActionButton(),
      body: SafeArea(
        child: StreamBuilder(
          stream: firebaseApi.getAllOffers,
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
                  'No offers added',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ).center,
              );
            }

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
                Expanded(
                  child: ListView(
                    children: [
                      ...snapshot.data!.docs.map((DocumentSnapshot document) {
                        try {
                          Offer? offer = Offer.fromJson(
                            document.data() as Map<String, dynamic>,
                          );

                          return Column(
                            children: [
                              buildOfferCard(
                                offer: offer,
                              ).paddingOnly(top: 20),
                            ],
                          );
                        } catch (e) {
                          return const SizedBox();
                        }
                      }),
                      Spacing.h100,
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 20);
          },
        ),
      ),
    );
  }

  Future<void> fetchDataFromFirestore() async {
    showLoading = true;
    try {
      QuerySnapshot<Map<String, dynamic>> categories =
          await FirebaseFirestore.instance.collection('offerCategories').get();
      newCategories = [];
      for (int i = 0; i < categories.docs.length; i++) {
        Categories category = Categories.fromMap(categories.docs[i].data());
        newCategories.add(category);
      }
    } catch (error) {
      log('Error fetching data from Firestore: $error');
    }
    showLoading = false;
    setState(() {});
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

  Widget buildOfferCard({required Offer offer}) {
    DateTime? startDate;
    DateTime? endDate;
    String? categoryName;

    bool showItem = false;

    if (offer.validDates?.length == 2) {
      startDate = offer.validDates?.first.toDate();
      endDate = offer.validDates?.last.toDate();
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
      for (Categories cat in newCategories) {
        if (cat.id == offer.categoryId) {
          categoryName = cat.name;
        }
      }
      return Container(
        width: Screen.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 3),
              spreadRadius: 2,
              color: Colors.grey.shade100,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (offer.photos != null && offer.photos!.isNotEmpty)
              GestureDetector(
                onTap: () {
                  ViewPhotosBottomSheet.getImages(
                    context,
                    allImages: offer.photos,
                    offer: offer.name,
                  );
                },
                child: Stack(
                  children: [
                    TAImage(
                      offer.photos!.first,
                      width: Screen.width,
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
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Text(
                          offer.photos!.length.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ).center,
                      ),
                    ),
                  ],
                ),
              ),
            Spacing.h15,
            Text(
              offer.name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              categoryName ?? '-',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.75),
              ),
            ),
            if (startDate != null && endDate != null)
              buildContent(
                title: 'Valid Until',
                value: '${DateFormat("dd/MM/yyyy").format(startDate)} - ${DateFormat("dd/MM/yyyy").format(endDate)}',
              ),
            Spacing.h10,
            Text(
              offer.description ?? '--',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black.withOpacity(0.5),
              ),
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
                        text: offer.createdBy ?? '-',
                      ),
                    ],
                  ),
                ).left,
                const Spacer(),
                IconButton(
                  onPressed: () {
                    onEditPressed(context, offer, newCategories);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    deleteDialog(context, offer: offer);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ).paddingSymmetric(horizontal: 10, vertical: 10),
      );
    }
    return const SizedBox();
  }

  onEditPressed(BuildContext context, Offer? offer, List<Categories> categories) {
    Navigator.push(context, AddOffersView.route(offer, categories));
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

  Future<void> deleteDialog(
    BuildContext context, {
    required Offer offer,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: Text(
            '${offer.name} will be completely deleted',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            AppButton.miniText(
              text: 'Cancel',
              onTap: () {
                Navigator.pop(context);
              },
            ),
            AppButton.miniFlat(
              text: 'Okay',
              onTap: () {
                firebaseApi.deleteOffer(offer.id);
                Navigator.pop(context);
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
        Navigator.push(context, AddOffersView.route(null, newCategories));
      },
      backgroundColor: AppColors.background.black,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
