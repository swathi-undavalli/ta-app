import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/models/checklist_model.dart';
import '../../../employees/model/employee.dart';
import '../screens/new_checklist_view.dart';

class NewChecklistLogic {
  NewChecklistController controller = Get.put(NewChecklistController());

  void onDeletePressed(int index) {
    if (controller.selectedIndex == index) {
      controller.selectedIndex = null;
      controller.focusNodes[index].unfocus();
    }
    controller.checkListItems.remove(controller.checkListItems[index]);
    controller.update();
  }

  void onAddPressed() {
    controller.checkListItems.add(TextEditingController(text: ' '));
    controller.selectedIndex = controller.checkListItems.length - 1;
    controller.focusNodes.add(FocusNode());
    controller.focusNodes[controller.selectedIndex!].requestFocus();
    controller.update();
  }

  Future<void> onSavePressed(BuildContext context, TemplateType templateType) async {
    if (controller.isValid()) {
      controller.showLoading = true;
      controller.update();

      DocumentReference employeeChecklistRef =
          FirebaseFirestore.instance.collection('employeeChecklists').doc(currentEmployee!.id);
      DocumentReference templateChecklistRef = FirebaseFirestore.instance.collection('templates').doc('template');

      Checklist? checklist;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot checklistSnapshot;
        if (templateType == TemplateType.newTemplate) {
          checklistSnapshot = await transaction.get(templateChecklistRef);
        } else {
          checklistSnapshot = await transaction.get(employeeChecklistRef);
        }
        Map<String, dynamic>? data = checklistSnapshot.data() as Map<String, dynamic>?;

        checklist = Checklist.fromMap(data);

        String? id = '';
        switch (templateType) {
          case TemplateType.existingChecklist:
            id = controller.id;
            break;
          case TemplateType.customChecklist:
          case TemplateType.newTemplate:
            id = (checklist!.checklistElement?.length ?? 0).toString();
            break;
        }

        ChecklistElement newChecklistElement = ChecklistElement(
          items: controller.checkListItems.map((e) => Item(name: e.text, isChecked: false)).toList(),
          employeeId: currentEmployee!.id,
          title: controller.titleTED.text,
          description: controller.descriptionTED.text,
          id: id ?? '',
        );

        if (templateType == TemplateType.existingChecklist) {
          checklist?.checklistElement?.removeWhere((c) => c.id == controller.id);
        }

        checklist?.checklistElement?.add(newChecklistElement);
        if (templateType == TemplateType.newTemplate) {
          transaction.set(templateChecklistRef, checklist?.toMap());
        } else {
          transaction.set(employeeChecklistRef, checklist?.toMap());
        }
      });

      controller.showLoading = false;
      controller.update();
      Get.back();
      Get.back();
      Get.back();
      controller.clear();
    }
  }
}

class NewChecklistController extends GetxController {
  List<TextEditingController> checkListItems = [];
  TextEditingController titleTED = TextEditingController();
  TextEditingController descriptionTED = TextEditingController();
  int? selectedIndex;
  List<FocusNode> focusNodes = [];
  bool showLoading = false;
  String? titleError;
  String? id;

  bool isValid() {
    bool isValid = true;
    titleError = null;

    if (titleTED.text.isEmpty) {
      titleError = 'Required';
      isValid = false;
      update();
    }

    return isValid;
  }

  void clear() {
    titleError = null;
    selectedIndex = null;
    showLoading = false;
    titleTED.text = '';
    checkListItems = [];
    focusNodes = [];
    id = null;
  }
}
