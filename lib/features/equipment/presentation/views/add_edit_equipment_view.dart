import 'dart:io';

import 'package:flutter/material.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../../certifications/presentation/widgets/pick_photos_widget.dart';
import '../../Repository/equipment_repo.dart';
import '../../models/equipment_model.dart';
import '../widgets/category_edit_bottomsheet.dart';

class AddEditEquipmentView extends StatefulWidget {
  const AddEditEquipmentView({super.key, required this.equipmentItem});

  final EquipmentItem? equipmentItem;

  static Route route(EquipmentItem? equipmentItem) => MaterialPageRoute(
        builder: (context) => AddEditEquipmentView(equipmentItem: equipmentItem),
      );

  @override
  State<AddEditEquipmentView> createState() => _AddEditEquipmentViewState();
}

class _AddEditEquipmentViewState extends State<AddEditEquipmentView> {
  List<EquipmentCategory> categories = [];
  EquipmentCategory? selectedCategory;
  late TextEditingController equipmentNameTED;
  late TextEditingController equipmentIdTED;
  List<String> equipmentIdsList = [];
  List<EquipmentPiece> equipmentPiecesList = [];
  String? pickedImage;
  bool showLoading = false;
  String? selectCategoryError;
  String? equipmentNameError;
  String? equipmentNoError;
  String? pickedImageError;

  @override
  void initState() {
    super.initState();
    equipmentNameTED = TextEditingController(text: widget.equipmentItem?.name);
    equipmentIdTED = TextEditingController();
    loadCategories();

    if (widget.equipmentItem != null) {
      loadEquipmentIds(widget.equipmentItem!.name);
      pickedImage = widget.equipmentItem?.photo;
    }
  }

  Future<void> loadCategories() async {
    showLoading = true;
    categories = await EquipmentRepo.fetchCategories();
    showLoading = false;

    // If editing, check if selectedCategory exists in the fetched categories
    if (widget.equipmentItem != null &&
        categories.any((category) => category.id == widget.equipmentItem!.category.id)) {
      selectedCategory = widget.equipmentItem!.category;
    } else {
      selectedCategory = null; // Reset if the category is not in the list
    }

    setState(() {});
  }

  Future<void> loadEquipmentIds(String equipmentName) async {
    showLoading = true;
    equipmentPiecesList = await EquipmentRepo.fetchEquipmentPiecesByEquipmentName(equipmentName);
    for (var i in equipmentPiecesList) {
      equipmentIdsList.add(i.equipmentId);
    }
    showLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(heading: 'Add Equipment'),
      backgroundColor: AppColors.background.lightBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSelectCategoryDropdown(),
                if (selectCategoryError != null)
                  Text(
                    selectCategoryError!,
                    style: TextStyle(color: Colors.red.shade800, fontSize: 12),
                  ),
                AppTextField(
                  hintText: 'Equipment Name',
                  controller: equipmentNameTED,
                  errorValidator: () {
                    return equipmentNameError;
                  },
                  required: true,
                ),
                if (equipmentIdsList.isNotEmpty) buildEquipmentNoChips().paddingOnly(top: 10),
                AppTextField(
                  controller: equipmentIdTED,
                  hintText: 'Equipment No',
                  required: true,
                  errorValidator: () {
                    return equipmentNoError;
                  },
                  suffixIcon: TextButton(
                    onPressed: () {
                      if (equipmentIdTED.text.isNotEmpty) {
                        equipmentIdsList.add(equipmentIdTED.text);
                      }
                      equipmentIdTED.text = '';
                      setState(() {});
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Spacing.h20,
                PickPhotosWidget(
                  pickedImage: pickedImage,
                  onChanged: (File? image) async {
                    if (image != null) {
                      setState(() {
                        showLoading = true;
                      });
                      pickedImage = await uploadImage(image, 'Images');
                      setState(() {
                        showLoading = false;
                      });
                    }
                  },
                ),
                Spacing.h10,
                if (pickedImageError != null)
                  Text(
                    pickedImageError!,
                    style: TextStyle(color: Colors.red.shade800, fontSize: 12),
                  ).paddingOnly(left: 5),
                Spacing.h100,
                buildSubmitButton(context).center,
              ],
            ).paddingAll(20).scrollable,
            buildShowLoading(),
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return AppButton.flat(
      text: (widget.equipmentItem == null) ? 'Submit' : 'Update',
      onTap: () async {
        if (isValid()) {
          showLoading = true;
          setState(() {});

          if (widget.equipmentItem == null) {
            await EquipmentRepo.addEquipmentItem(
              equipmentCategoryModel: selectedCategory!,
              equipmentName: equipmentNameTED.text,
              photo: pickedImage!,
              equipmentIds: equipmentIdsList,
            );
          } else {
            await EquipmentRepo.editEquipmentItem(
              equipmentId: widget.equipmentItem!.id,
              equipmentCategory: selectedCategory!,
              equipmentName: equipmentNameTED.text,
              photo: pickedImage!,
              updatedEquipmentIds: equipmentIdsList,
              equipmentPieces: equipmentPiecesList,
            );
          }

          if (context.mounted) {
            Navigator.pop(context);
          }
          showLoading = false;
          setState(() {});
        }
      },
      color: Colors.black,
      textColor: Colors.white,
    );
  }

  Widget buildShowLoading() {
    if (showLoading) {
      return Container(
        height: Screen.height,
        width: Screen.width,
        color: Colors.white,
        child: const CircularProgressIndicator().center,
      );
    }
    return const SizedBox();
  }

  isValid() {
    bool isValid = true;
    selectCategoryError = null;
    equipmentNameError = null;
    equipmentNoError = null;
    pickedImageError = null;

    if (selectedCategory == null) {
      isValid = false;
      selectCategoryError = 'Required';
      setState(() {});
    }
    if (equipmentNameTED.text.isEmpty) {
      isValid = false;
      equipmentNameError = 'Required';
      setState(() {});
    }
    if (equipmentIdsList.isEmpty) {
      isValid = false;
      equipmentNoError = 'Add atleast one equipment id';
      setState(() {});
    }
    if (pickedImage == null) {
      isValid = false;
      pickedImageError = 'Photo Required';
      setState(() {});
    }
    return isValid;
  }

  Widget buildEquipmentNoChips() {
    return Wrap(
      spacing: 10,
      children: [
        ...equipmentIdsList.map((e) {
          return InkWell(
            onTap: () {
              equipmentIdsList.remove(e);
              setState(() {});
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(e),
                  Spacing.w7,
                  const Icon(
                    Icons.close,
                    size: 15,
                  ),
                  Spacing.w5,
                ],
              ).paddingAll(5),
            ),
          );
        }),
      ],
    );
  }

  Widget buildSelectCategoryDropdown() {
    return DropdownButton(
      underline: Container(height: 1, color: Colors.grey),
      isExpanded: true,
      value: selectedCategory,
      onChanged: (dynamic type) async {
        if (type.name == 'Add / Edit') {
          selectedCategory = null;
          setState(() {});

          List<EquipmentCategory> updatedCategories = await CategorySelectorBottomSheet.show(context, categories);
          setState(() {
            categories = updatedCategories;
          });
        } else {
          setState(() {
            selectedCategory = type;
          });
        }
      },
      hint: const Text(
        'Select Category',
        style: TextStyle(
          fontSize: FontSize.small,
          fontFamily: AppFonts.nunito,
          color: Colors.black87,
        ),
      ),
      elevation: 0,
      dropdownColor: Colors.white,
      items: [...categories, const EquipmentCategory(name: 'Add / Edit', id: 'id')].map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value.name,
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.nunito,
              color: (value.name == 'Add / Edit') ? Colors.blue : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
