import 'dart:io';

import 'package:flutter/material.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../../certifications/presentation/widgets/pick_photos_widget.dart';
import '../widgets/equipment_edit_bottomsheet.dart';

class AddEquipmentView extends StatefulWidget {
  const AddEquipmentView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const AddEquipmentView(),
      );

  @override
  State<AddEquipmentView> createState() => _AddEquipmentViewState();
}

class _AddEquipmentViewState extends State<AddEquipmentView> {
  List<String> categoriesWithAddOption = ['Mask', 'Fins', 'BCD', 'Computer'];
  String? selectedCategory;
  late TextEditingController itemNameTED;
  late TextEditingController descriptionTED;
  late TextEditingController equipmentNoTED;
  List<String> equipmentNoList = [];
  String? pickedImage;
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    categoriesWithAddOption.add('Add / Edit');
    itemNameTED = TextEditingController();
    descriptionTED = TextEditingController();
    equipmentNoTED = TextEditingController();
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
              children: [
                buildSelectCategoryDropdown(),
                AppTextField(
                  hintText: 'Item Name',
                  controller: itemNameTED,
                  required: true,
                ),
                AppTextField(
                  hintText: 'Description',
                  controller: descriptionTED,
                ),
                buildEquipmentNoChips(),
                AppTextField(
                  hintText: 'Equipment No',
                  controller: equipmentNoTED,
                  suffixIcon: TextButton(
                    onPressed: () {
                      if (equipmentNoTED.text.isNotEmpty) {
                        equipmentNoList.add(equipmentNoTED.text);
                      }
                      equipmentNoTED.text = '';
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
                  pickedImage: null,
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
                Spacing.h100,
                AppButton.flat(
                  text: 'Submit',
                  onTap: () {},
                  color: Colors.black,
                  textColor: Colors.white,
                ),
              ],
            ).paddingAll(20).scrollable,
            if (showLoading)
              Container(
                height: Screen.height,
                width: Screen.width,
                color: Colors.white,
                child: const CircularProgressIndicator().center,
              ),
          ],
        ),
      ),
    );
  }

  Widget buildEquipmentNoChips() {
    return Wrap(
      spacing: 10,
      children: [
        ...equipmentNoList.map((e) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(e),
                Spacing.w7,
                InkWell(
                  onTap: () {
                    equipmentNoList.remove(e);
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.close,
                    size: 15,
                  ),
                ),
                Spacing.w5,
              ],
            ).paddingAll(5),
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
      onChanged: (dynamic type) {
        if (type == 'Add / Edit') {
          EquipmentSelectorBottomSheet.show(context);
        } else {
          selectedCategory = type;
          setState(() {});
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
      items: categoriesWithAddOption.map((value) {
        return DropdownMenuItem(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.nunito,
              color: (value == 'Add / Edit') ? Colors.blue : Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}
