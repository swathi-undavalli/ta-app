import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/ta_image.dart';
import '../../controllers/add_offers_controller.dart';
import '../../models/category.dart';
import '../../models/offer.dart';

class AddOffersView extends StatefulWidget {
  const AddOffersView({Key? key, required this.offer}) : super(key: key);
  final Offer? offer;

  static Route route(Offer? offer) => MaterialPageRoute(
        builder: (context) => AddOffersView(
          offer: offer,
        ),
      );

  @override
  State<AddOffersView> createState() => _AddOffersViewState();
}

class _AddOffersViewState extends State<AddOffersView> {
  AddOffersLogic logic = AddOffersLogic();

  @override
  void initState() {
    super.initState();
    logic.controller.clear();
    logic.controller.offer = widget.offer;

    if (logic.controller.offer != null) {
      logic.init(logic.controller.offer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            logic.controller.clear();
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColors.background.lightBlue,
            appBar: AppBarWidget(
              heading: (logic.controller.offer != null) ? 'Edit Offer' : 'Add Offer',
            ),
            body: GetBuilder<AddOffersController>(
              builder: (controller) {
                return SafeArea(
                  child: Column(
                    children: [
                      buildCategoryDropdown(),
                      Spacing.h15,
                      buildName(),
                      Spacing.h30,
                      buildValidDates(),
                      Spacing.h30,
                      buildDescription(),
                      Spacing.h30,
                      buildUploadPhotos(),
                      Spacing.h50,
                      buildAddButton(),
                      Spacing.h30,
                    ],
                  ).paddingAll(20).scrollable,
                );
              },
            ),
          ),
        ),
        buildShowLoading(),
      ],
    );
  }

  Widget buildShowLoading() {
    return GetBuilder<AddOffersController>(
      builder: (controller) {
        if (controller.showLoading) {
          return Material(
            color: Colors.transparent,
            child: Container(
              color: Colors.black54,
              height: Screen.height,
              width: Screen.width,
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

  Widget buildAddButton() {
    return AppButton.flat(
      text: (logic.controller.offer != null) ? 'Update' : 'Add',
      onTap: () async {
        await logic.onAddPressed();
        if (mounted) {
          Navigator.pop(context);
        }
      },
      color: Colors.black,
      textColor: Colors.white,
    );
  }

  Widget buildUploadPhotos() {
    return GetBuilder<AddOffersController>(
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            if (controller.pickedMediaFiles.isEmpty) {
              _showImageSourceBottomSheet();
            }
          },
          child: (controller.pickedMediaFiles.isEmpty) ? _buildNoImageBox() : buildPhotos(),
        );
      },
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              ListTile(
                leading: TAImage(
                  AppImages.icons.camera,
                ),
                title: const Text(
                  'Camera',
                ),
                onTap: () {
                  Navigator.pop(context);
                  logic.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: TAImage(
                  AppImages.icons.gallery,
                ),
                title: const Text(
                  'Gallery',
                ),
                onTap: () {
                  Navigator.pop(context);
                  logic.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoImageBox() {
    return Container(
      height: 183,
      width: Screen.width,
      decoration: BoxDecoration(
        // color: const Color(0xffC4C4C4),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TAImage(AppImages.icons.add, color: Colors.black, height: 30, width: 30),
          Spacing.h33,
          const Text('Add Photos'),
        ],
      ),
    ).center;
  }

  Widget buildPhotos() {
    return GetBuilder<AddOffersController>(
      builder: (controller) {
        return Container(
          height: 183,
          width: Screen.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xffc4c4c4),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.black.withOpacity(0.6),
                const Color(0x00000000),
              ],
            ),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: controller.pickedMediaFiles.isNotEmpty
                    ? Image.file(
                        controller.pickedMediaFiles[controller.selectedImageIndex],
                        height: Screen.width * 4 / 3,
                        width: Screen.width,
                        fit: BoxFit.cover,
                      )
                    : _buildNoImageBox(),
              ),
              if (controller.pickedMediaFiles.isNotEmpty)
                Positioned(
                  bottom: 16,
                  child: SizedBox(
                    height: 40,
                    width: Screen.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(controller.pickedMediaFiles.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                logic.onImageHolderTap(index);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: index == controller.selectedImageIndex ? 1.5 : 0,
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3),
                                  child: Image.file(
                                    controller.pickedMediaFiles[index],
                                    height: 45,
                                    width: 45,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ).paddingOnly(right: 5);
                          }),
                          GestureDetector(
                            onTap: () {
                              if (!controller.showLoading) {
                                _showImageSourceBottomSheet();
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: AppColors.text.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: TAImage(
                                AppImages.icons.add,
                                color: Colors.black,
                                height: 14,
                                width: 14,
                              ).center,
                            ),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 100),
                    ),
                  ),
                ),
              Positioned(
                right: 10,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    if (!controller.showLoading) logic.onImageDeleteTap();
                  },
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                    child: TAImage(
                      AppImages.icons.cancel,
                      height: 24,
                      width: 24,
                      color: Colors.black,
                    ).paddingAll(5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).center;
  }

  Widget buildName() {
    return TextField(
      controller: logic.controller.nameTED,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildDescription() {
    return TextField(
      controller: logic.controller.descriptionTED,
      maxLines: 3,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButton<Categories>(
        hint: const Text('Select Category'),
        underline: Container(height: 0, color: Colors.transparent),
        isExpanded: true,
        value: logic.controller.selectedCategory,
        onChanged: (Categories? newValue) {
          logic.controller.selectedCategory = newValue;
          logic.controller.update();
        },
        items: logic.offersLogic.controller.categories.map((value) {
          return DropdownMenuItem<Categories>(
            value: value,
            child: Text(
              value.name,
            ),
          );
        }).toList(),
      ).paddingSymmetric(horizontal: 15, vertical: 5),
    );
  }

  Widget buildValidDates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: Screen.width,
                child: Text(
                  'Valid Dates',
                  style: TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            (logic.controller.startDate == null && logic.controller.endDate == null)
                ? AppButton.miniFlat(
                    onTap: () {
                      showDateRangePickerBottomSheet(context);
                    },
                    text: 'Apply',
                  ).center
                : GestureDetector(
                    onTap: () {
                      showDateRangePickerBottomSheet(context);
                    },
                    child: const Text(
                      'Change',
                      style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                    ),
                  ),
          ],
        ),
        Spacing.h10,
        if (logic.controller.startDate != null && logic.controller.endDate != null)
          Text(
            "${DateFormat("dd-MM-yyyy").format(logic.controller.startDate!)} - ${DateFormat("dd-MM-yyyy").format(logic.controller.endDate!)}",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  Future showDateRangePickerBottomSheet(BuildContext context) {
    return showDateRangePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff376aed),
            ),
          ),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              ),
            ],
          ),
        );
      },
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      currentDate: DateTime.now(),
    ).then((pickedDateRange) async {
      if (pickedDateRange != null) {
        logic.controller.dateRange = pickedDateRange;
        logic.controller.startDate = logic.controller.dateRange!.start;
        logic.controller.endDate = logic.controller.dateRange!.end;
      }
      logic.controller.update();
      logic.controller.validDates = [];

      logic.controller.showLoading = true;

      if (logic.controller.startDate != null) {
        Timestamp startTimestamp = Timestamp.fromDate(logic.controller.startDate!);
        logic.controller.validDates.add(startTimestamp);
      }
      if (logic.controller.endDate != null) {
        Timestamp endTimestamp = Timestamp.fromDate(logic.controller.endDate!);
        logic.controller.validDates.add(endTimestamp);
      }
      logic.controller.showLoading = false;
    });
  }
}
