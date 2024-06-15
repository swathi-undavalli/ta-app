import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/checklist_model.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../controllers/new_checklist_controller.dart';

class NewChecklistView extends StatefulWidget {
  const NewChecklistView({Key? key, required this.checkListElement, required this.templateType}) : super(key: key);

  final ChecklistElement checkListElement;
  final TemplateType templateType;

  static Route route(ChecklistElement checkListElement, TemplateType templateType) => MaterialPageRoute(
        builder: (context) => NewChecklistView(
          checkListElement: checkListElement,
          templateType: templateType,
        ),
      );

  @override
  State<NewChecklistView> createState() => _NewChecklistViewState();
}

class _NewChecklistViewState extends State<NewChecklistView> {
  final NewChecklistLogic logic = NewChecklistLogic();

  late ChecklistElement? checkListElement;
  late TemplateType? templateType;

  @override
  void initState() {
    checkListElement = widget.checkListElement;
    templateType = widget.templateType;
    logic.controller.checkListItems =
        (checkListElement?.items ?? []).map((e) => TextEditingController(text: e.name)).toList();
    logic.controller.focusNodes = (checkListElement?.items ?? []).map((e) => FocusNode()).toList();
    logic.controller.id = (templateType == TemplateType.existingChecklist) ? checkListElement?.id : null;
    logic.controller.titleTED.text = (checkListElement?.title ?? '');
    logic.controller.descriptionTED.text = (checkListElement?.description ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewChecklistController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background.lightBlue,
          appBar: _buildAppBar(context),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              logic.onAddPressed();
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
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
                    Spacing.h40,
                  ],
                ).paddingSymmetric(horizontal: 20, vertical: 30).scrollable,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckList() {
    return Column(
      children: [
        if (logic.controller.checkListItems.isEmpty)
          SizedBox(
            height: Screen.height / 2,
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
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.background.skyBlue.withOpacity(0.2),
              border: Border.all(
                color: (logic.controller.selectedIndex == index) ? Colors.black : Colors.transparent,
              ),
            ),
            width: Screen.width,
            child: TextField(
              onTap: () {
                logic.controller.selectedIndex = index;
                logic.controller.update();
              },
              focusNode: logic.controller.focusNodes[index],
              controller: logic.controller.checkListItems[index],
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                hintText: 'Enter text',
                hintStyle: const TextStyle(fontSize: 14),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {
                    logic.onDeletePressed(index);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                    size: 20,
                    // color: Colors.white,
                  ),
                ),
              ),
            ).left,
          ).paddingOnly(bottom: 10);
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
            child: const Text(
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
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.text.black,
            size: 17,
          ),
        ),
      ),
      title: Text(
        heading,
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

  String get heading {
    if (templateType == TemplateType.newTemplate) {
      return 'New Template';
    } else if (templateType == TemplateType.customChecklist) {
      return 'Custom Checklist';
    } else {
      return logic.controller.titleTED.text;
    }
  }

  Future<void> saveChecklistDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GetBuilder<NewChecklistController>(
          builder: (controller) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
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
                            hintStyle: TextStyle(color: Colors.black, fontSize: 12),
                            hintText: 'Description',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: Screen.height / 2,
                      color: Colors.white,
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
                      Navigator.pop(context);
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
                      await logic.onSavePressed(context, templateType!);
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

enum TemplateType {
  existingChecklist,
  customChecklist,
  newTemplate,
}
