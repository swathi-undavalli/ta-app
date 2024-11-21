import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/image_uploader.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../models/equipment_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/category_edit_bottomsheet.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';
import 'manage_assigned_ids_bottom_sheet.dart';

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
  List<Tag> _assignedTags = [];
  String? _uploadedImage;
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
        _assignedTags = pieces.map((piece) {
          return piece.tag;
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
        description: _isEditMode ? 'Update ${widget.equipmentItem?.name}' : 'Add new equipment',
        action: _isEditMode
            ? IconButton(
                onPressed: () async {
                  await context.read<EquipmentProvider>().deleteEquipmentItem(widget.equipmentItem!);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_forever),
              ).paddingOnly(right: 20)
            : null,
      ),
      body: EquipmentBody(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EquipmentCategorySelector(
                  onChanged: (EquipmentCategory? category) async {
                    if (category?.name == 'Add / Edit') {
                      List<EquipmentCategory> updatedCategories =
                          await CategorySelectorBottomSheet.show(context, context.read<EquipmentProvider>().categories);
                      if (!context.mounted) return;
                      context.read<EquipmentProvider>().categories = updatedCategories;
                      return;
                    }
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
                  textCapitalization: TextCapitalization.words,
                  required: true,
                ),
                _AssignedTags(
                  tags: _assignedTags,
                  onChanged: (updatedTags) {
                    setState(() {
                      _assignedTags = updatedTags;
                    });
                  },
                ),
                _FieldError(_assignedIDsError),
                Spacing.h20,
                Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Photo : ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.w8,
                        const Text(
                          'upload new or replace old photo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ).left,
                      ],
                    ),
                    Spacing.h8,
                    Row(
                      children: [
                        ImageUploader(
                          initialImage: widget.equipmentItem?.photo,
                          onImageUploaded: (String imageUrl) => _uploadedImage = imageUrl,
                        ),
                        _FieldError(_pickedImageError),
                      ],
                    ),
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
        photo: _uploadedImage,
      );
      await context.read<EquipmentProvider>().updateEquipmentItemAndPieces(
            updatedItem,
            _assignedTags,
            _pieces,
          );
      if (!mounted) return;
      context.read<EquipmentProvider>().fetchEquipmentItems(true);
      Navigator.pop(context);
      return;
    }

    if (_validateFields()) {
      await context.read<EquipmentProvider>().addEquipment(
            _selectedCategory!,
            _equipmentNameTED.text,
            _assignedTags,
            _uploadedImage!,
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
    if (_assignedTags.isEmpty) {
      isValid = false;
      _assignedIDsError = 'Add at least one equipment id';
    }
    if (_uploadedImage == null) {
      isValid = false;
      _pickedImageError = 'Photo Required / wait until loading finishes';
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

class _AssignedTags extends StatelessWidget {
  final List<Tag> tags;
  final Function(List<Tag> updatedTags) onChanged;

  const _AssignedTags({required this.tags, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacing.h24,
        Row(
          children: [
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ).left,
            const Spacer(),
            AppButton.miniFlat(
              text: 'Add Tag',
              onTap: () async {
                var newTags = await AddTagBottomSheet.show(context, null);
                onChanged([
                  ...tags,
                  ...newTags as List<Tag>,
                ]);
              },
            )
          ],
        ),
        Spacing.h16,
        if (tags.isNotEmpty)
          Column(
            children: [
              for (int i = 0; i < tags.length; i++) buildTag(context, i),
            ],
          ).paddingOnly(top: 10),
      ],
    );
  }

  Widget buildTag(BuildContext context, int index) {
    final currentTag = tags[index];
    return Container(
      width: Screen.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: appBlue.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentTag.id,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (currentTag.serialNumber != null)
                Text(
                  'Sl. No: ${currentTag.serialNumber!}',
                  style: _subTextStyle,
                ),
              if (currentTag.remarks != null)
                Text(
                  'Remarks: ${currentTag.remarks!}',
                  style: _subTextStyle,
                ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 5),
          const Spacer(),
          IconButton(
            onPressed: () {
              List<Tag> updatedList = List.of(tags);
              updatedList.removeAt(index);
              onChanged(updatedList);
            },
            icon: const Icon(
              Icons.delete,
              size: 18,
            ),
          ),
          IconButton(
            onPressed: () async {
              var newTags = await AddTagBottomSheet.show(context, currentTag);
              log(newTags.toString());
              if ((newTags ?? []).isEmpty) return;
              List<Tag> updatedList = List.of(tags);
              updatedList[index] = newTags!.first;
              onChanged(updatedList);
            },
            icon: const Icon(
              Icons.edit,
              size: 18,
            ),
          ),
        ],
      ),
    ).paddingOnly(bottom: 8);
  }

  TextStyle get _subTextStyle {
    return const TextStyle(
      color: Colors.grey,
      fontSize: 12,
    );
  }
}

class _EquipmentCategorySelector extends StatefulWidget {
  final Function(EquipmentCategory? category) onChanged;
  final EquipmentCategory? selectedCategory;

  const _EquipmentCategorySelector({required this.onChanged, required this.selectedCategory});

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
              const EquipmentCategory(name: 'Add / Edit', id: 'id'),
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
