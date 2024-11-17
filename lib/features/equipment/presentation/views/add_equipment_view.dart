import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../../certifications/presentation/widgets/pick_photos_widget.dart';
import '../../models/equipment_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';

//TODO : Check/Verify AppTextField
//TODO : Implement edit feature
//TODO : Add smoother animations

class AddEquipmentView extends StatefulWidget {
  final EquipmentItem? equipmentItem;

  const AddEquipmentView({super.key, required this.equipmentItem});

  static Route route(EquipmentItem? equipmentItem) => MaterialPageRoute(
        builder: (context) => AddEquipmentView(equipmentItem: equipmentItem),
        settings: const RouteSettings(name: 'AddEquipmentView'),
      );

  @override
  State<AddEquipmentView> createState() => _AddEquipmentViewState();
}

class _AddEquipmentViewState extends State<AddEquipmentView> {
  EquipmentCategory? _selectedCategory;
  late TextEditingController _equipmentNameTED;
  List<String> _assignedIds = [];
  String? _pickedImage;
  bool _showImageUploadingLoading = false;
  String? _selectCategoryError;
  String? _nameError;
  String? _assignedIDsError;
  String? _pickedImageError;
  List<EquipmentPiece> _pieces = [];

  @override
  void initState() {
    super.initState();
    _equipmentNameTED = TextEditingController(text: widget.equipmentItem?.name);
    _selectedCategory = widget.equipmentItem?.category;
    if (_isEditMode) {
      context.read<EquipmentProvider>().repository.getEquipmentPieces(widget.equipmentItem!.id).then((pieces) {
        _pieces = pieces;
        _assignedIds = pieces.map((piece) {
          return piece.assignedID;
        }).toList();
        setState(() {});
      });
    }
  }

  bool get _isEditMode => widget.equipmentItem != null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: EquipmentAppBar(
        title: _isEditMode ? 'Edit Equipment' : 'Add Equipment',
        description: 'Update ${widget.equipmentItem?.name}',
      ),
      body: EquipmentBody(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EquipmentCategorySelector(
                  onChanged: (EquipmentCategory? category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  selectedCategory: _selectedCategory,
                ),
                _FieldError(_selectCategoryError),
                AppTextField(
                  hintText: 'Equipment Name',
                  controller: _equipmentNameTED,
                  validator: (_) => _nameError,
                  required: true,
                ),
                _AssignedIdsFiled(
                  ids: _assignedIds,
                  onChanged: (updatedIds) {
                    setState(() {
                      _assignedIds = updatedIds;
                    });
                  },
                ),
                _FieldError(_assignedIDsError),
                Spacing.h20,
                if (!_isEditMode)
                  Row(
                    children: [
                      PickPhotosWidget(
                        pickedImage: _pickedImage,
                        onChanged: (File? image) async {
                          if (image != null) {
                            setState(() {
                              _showImageUploadingLoading = true;
                            });
                            _pickedImage = await uploadImage(image, 'Images');
                            setState(() {
                              _showImageUploadingLoading = false;
                            });
                          }
                        },
                      ),
                      _FieldError(_pickedImageError),
                      if (_showImageUploadingLoading)
                        const CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 2,
                        ).size(15, 15),
                    ],
                  ),
                Spacing.h100,
                AppButton.flat(
                  text: (widget.equipmentItem == null) ? 'Submit' : 'Update',
                  onTap: onSaveOrUpdate,
                  color: Colors.black,
                  textColor: Colors.white,
                ).center,
              ],
            ).paddingAll(20).scrollable,
            const _LoadingAnimation(),
          ],
        ),
      ),
    );
  }

  Future<void> onSaveOrUpdate() async {
    if (_isEditMode) {
      EquipmentItem updatedItem = widget.equipmentItem!.copyWith(
        category: _selectedCategory,
        name: _equipmentNameTED.text,
      );
      await context.read<EquipmentProvider>().updateEquipmentItemAndPieces(
            updatedItem,
            _assignedIds,
            _pieces,
          );

      context.read<EquipmentProvider>().fetchEquipmentItems(true);

      if (mounted) Navigator.pop(context);

      return;
    }

    if (_validateFields()) {
      await context.read<EquipmentProvider>().addEquipment(
            _selectedCategory!,
            _equipmentNameTED.text,
            _assignedIds,
            _pickedImage!,
          );

      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      setState(() {});
    }
  }

  bool _validateFields() {
    bool isValid = true;
    _selectCategoryError = null;
    _nameError = null;
    _assignedIDsError = null;
    _pickedImageError = null;

    if (_selectedCategory == null) {
      isValid = false;
      _selectCategoryError = 'Required';
    }
    if (_equipmentNameTED.text.isEmpty) {
      isValid = false;
      _nameError = 'Required';
    }
    if (_assignedIds.isEmpty) {
      isValid = false;
      _assignedIDsError = 'Add atleast one equipment id';
    }
    if (_pickedImage == null) {
      isValid = false;
      _pickedImageError = 'Photo Required';
    }
    return isValid;
  }
}

class _LoadingAnimation extends StatelessWidget {
  const _LoadingAnimation();

  @override
  Widget build(BuildContext context) {
    return Selector<EquipmentProvider, EquipmentStatus>(
      selector: (context, provider) => provider.status,
      builder: (context, status, child) {
        if (status == EquipmentStatus.loaded || status == EquipmentStatus.error) return const SizedBox();
        return Container(
          height: Screen.height,
          width: Screen.width,
          color: Colors.white,
          child: const CircularProgressIndicator(
            color: Colors.black,
          ).center,
        );
      },
    );
  }
}

class _AssignedIdsFiled extends StatelessWidget {
  final List<String> ids;
  final Function(List<String> updatedIds) onChanged;

  const _AssignedIdsFiled({super.key, required this.ids, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Column(
      children: [
        if (ids.isNotEmpty)
          Wrap(
            spacing: 10,
            children: [
              ...ids.map((id) {
                return InkWell(
                  onTap: () {
                    List<String> updatedList = List.of(ids);
                    updatedList.remove(id);
                    onChanged(updatedList);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(id),
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
          ).paddingOnly(top: 10),
        AppTextField(
          controller: controller,
          hintText: 'Equipment No',
          required: true,
          onChangedCallBack: (String value) {
            //TODO: Add logic to auto add item when "," is pressed.
          },
          suffixIcon: TextButton(
            onPressed: () {
              String id = controller.text;
              if (id.isNotEmpty) {
                List<String> updatedList = List.of(ids);
                if (!updatedList.contains(id)) {
                  updatedList.add(id);
                  onChanged(updatedList);
                }
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _EquipmentCategorySelector extends StatefulWidget {
  final Function(EquipmentCategory? category) onChanged;
  final EquipmentCategory? selectedCategory;

  const _EquipmentCategorySelector({super.key, required this.onChanged, required this.selectedCategory});

  @override
  State<_EquipmentCategorySelector> createState() => _EquipmentCategorySelectorState();
}

class _EquipmentCategorySelectorState extends State<_EquipmentCategorySelector> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EquipmentProvider>().fetchCategories();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<EquipmentProvider, EquipmentStatus>(
      selector: (context, provider) => provider.status,
      builder: (context, status, child) {
        final bool isLoading = status == EquipmentStatus.loading;

        return IgnorePointer(
          ignoring: isLoading,
          child: DropdownButton<EquipmentCategory>(
            underline: Container(height: 1, color: Colors.grey),
            isExpanded: true,
            value: widget.selectedCategory,
            onChanged: widget.onChanged,
            // onChanged: (EquipmentCategory? category) {
            //
            //   // if (type.name == 'Add / Edit') {
            //   //
            //   //   List<EquipmentCategory> updatedCategories = await CategorySelectorBottomSheet.show(context, categories);
            //   //   setState(() {
            //   //     categories = updatedCategories;
            //   //   });
            //   // }
            //   // else {
            //   //   setState(() {
            //   //     selectedCategory = type;
            //   //   });
            //   // }
            // },
            hint: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 2,
                  ).size(15, 15).paddingOnly(left: 10)
                : const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: FontSize.small,
                      fontFamily: AppFonts.nunito,
                      color: Colors.black87,
                    ),
                  ),
            elevation: 0,
            dropdownColor: Colors.white,
            items: [
              ...context.read<EquipmentProvider>().categories,
              // const EquipmentCategory(name: 'Add / Edit', id: 'id'),
            ].map((value) {
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
          ),
        );
      },
    );
  }
}

class _FieldError extends StatelessWidget {
  final String? error;

  const _FieldError(this.error);

  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox();
    return Text(
      error!,
      style: TextStyle(color: Colors.red.shade800, fontSize: 12),
    );
  }
}
