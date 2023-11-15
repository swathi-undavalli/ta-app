import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/models/checklist_model.dart';
import '../../../../core/util/utils.dart';
import '../controllers/new_checklist_controller.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/app_measurements.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_button.dart';

class NewChecklistView extends StatefulWidget {
  static const String id = 'NewChecklistView';

  const NewChecklistView({Key? key}) : super(key: key);

  @override
  State<NewChecklistView> createState() => _NewChecklistViewState();
}

class _NewChecklistViewState extends State<NewChecklistView> {
  final NewChecklistLogic logic = NewChecklistLogic();

  final ChecklistElement? checkListElement = Get.arguments;

  @override
  void initState() {
    logic.controller.checkListItems = (checkListElement?.items ?? []);
    logic.controller.id = checkListElement?.id;
    logic.controller.titleTED.text = (checkListElement?.name ?? '');
    logic.controller.descriptionTED.text =
        (checkListElement?.description ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewChecklistController>(
      builder: (controller) {
        return Scaffold(
          appBar: _buildAppBar(context),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              logic.onAddPressed();
            },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: (logic.controller.checkListItems.isNotEmpty)
              ? _buildSelectedTF(context)
              : const SizedBox(),
          body: WillPopScope(
            onWillPop: () async {
              logic.controller.clear();
              return true;
            },
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDescription(),
                    Spacing.h20,
                    _buildCheckList(),
                  ],
                ).paddingSymmetric(horizontal: 20, vertical: 30).scrollable,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedTF(BuildContext context) {
    return AbsorbPointer(
      absorbing: (logic.controller.selectedIndex != null) ? false : true,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(3, 3),
              color: Colors.grey.shade300,
              blurRadius: 10,
            ),
          ],
        ),
        child: TextField(
          controller: logic.controller.inputTED,
          focusNode: logic.controller.focusNode,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            hintText: 'Enter text',
            hintStyle: const TextStyle(fontSize: 14),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              onPressed: () {
                if (logic.controller.selectedIndex != null) {
                  logic.controller
                          .checkListItems[logic.controller.selectedIndex!] =
                      logic.controller.inputTED.text;
                }
                logic.controller.focusNode.unfocus();
                logic.controller.selectedIndex = null;
                logic.controller.inputTED.text = '';
                logic.controller.update();
              },
            ),
          ),
        ).left,
      ).paddingOnly(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
    );
  }

  Widget _buildCheckList() {
    return Column(
      children: [
        if (logic.controller.checkListItems.isEmpty)
          SizedBox(
            height: Get.height / 2,
            child: const Text(
              'Tap add icon to add checklist',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: AppFonts.nunito,
                height: 1.5,
              ),
            ).center,
          ),
        ...List.generate(logic.controller.checkListItems.length, (index) {
          return GestureDetector(
            onTap: () {
              logic.controller.selectedIndex = index;
              logic.onChecklistPressed;
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.background.skyBlue.withOpacity(0.2),
                border: Border.all(
                  color: (logic.controller.selectedIndex == index)
                      ? Colors.black
                      : Colors.transparent,
                ),
              ),
              width: AppMeasures.screenWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(logic.controller.checkListItems[index])
                      .paddingSymmetric(vertical: 10, horizontal: 10)
                      .left,
                  IconButton(
                    onPressed: () {
                      logic.onDeletePressed(index);
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      // color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).paddingOnly(bottom: 10),
          );
        }),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background.white,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 80,
      actions: [
        if (logic.controller.checkListItems.isNotEmpty)
          TextButton(
            onPressed: () {
              if (logic.controller.checkListItems.isNotEmpty) {
                saveChecklistDialog(context);
              } else {
                showToast('Please add items');
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Spacing.w5,
      ],
      leading: Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          ),
        ),
      ),
      title: Text(
        (logic.controller.id != null)
            ? logic.controller.titleTED.text
            : 'Custom checklist',
        style: TextStyle(
          color: AppColors.text.black,
          fontSize: 18,
          fontFamily: AppFonts.nunito,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ).center,
    );
  }

  Future<void> saveChecklistDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GetBuilder<NewChecklistController>(
          builder: (controller) {
            return AlertDialog(
              title: const Text(
                'Please fill the below details before saving the checklist',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              content: (!controller.showLoading)
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: controller.titleTED,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                            border: const UnderlineInputBorder(),
                            errorText: controller.titleError,
                            errorStyle: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                        TextField(
                          controller: controller.descriptionTED,
                          decoration: const InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 12),
                            hintText: 'Description',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: Get.height / 2,
                      color: Colors.grey.shade100,
                      child: const CircularProgressIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.grey,
                      ).center,
                    ),
              actions: <Widget>[
                AppButton.miniText(
                  text: 'Cancel',
                  onTap: () {
                    if (!controller.showLoading) {
                      Get.back();
                      controller.titleTED.text = '';
                      controller.descriptionTED.text = '';
                      controller.titleError = null;
                      controller.showLoading = false;
                    }
                  },
                ),
                AppButton.miniFlat(
                  text: 'Okay',
                  onTap: () async {
                    if (!controller.showLoading) {
                      log('started');
                      await logic.onSavePressed(context);
                      log('ended');
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDescription() {
    return const Text(
      'Keep adding items and use the delete icon to delete or tap on item to edit',
      style: TextStyle(
        color: Colors.black,
        fontSize: 13,
        fontFamily: AppFonts.nunito,
        height: 1.5,
      ),
    );
  }
}
