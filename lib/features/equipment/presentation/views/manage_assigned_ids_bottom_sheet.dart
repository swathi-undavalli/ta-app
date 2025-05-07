import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/modal_wrapper.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../models/equipment_model.dart';

class AddTagBottomSheet extends StatefulWidget {
  final Tag? tag;

  const AddTagBottomSheet({super.key, this.tag});

  static Future<List<Tag>?> show(BuildContext context, Tag? tag) async {
    return await showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddTagBottomSheet(tag: tag),
    );
  }

  @override
  State<AddTagBottomSheet> createState() => _AddTagBottomSheetState();
}

class _AddTagBottomSheetState extends State<AddTagBottomSheet> {
  late final TextEditingController _serialNumberTED, _idTED, _remarksTED;
  final List<Tag> _tags = [];

  @override
  void initState() {
    super.initState();
    _serialNumberTED = TextEditingController(text: widget.tag?.serialNumber);
    _idTED = TextEditingController(text: widget.tag?.id);
    _remarksTED = TextEditingController(text: widget.tag?.remarks);
  }

  @override
  void dispose() {
    _serialNumberTED.dispose();
    _idTED.dispose();
    _remarksTED.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.tag != null;

  @override
  Widget build(BuildContext context) {
    return ModalWrapper(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
            color: AppColors.background.lightBlue,
          ),
          width: Screen.width,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    _isEditMode ? 'Edit tag' : 'Add new tag',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context, _tags);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ).paddingHorizontal(16),
              const Divider(
                height: 1,
                color: Colors.grey,
              ).paddingHorizontal(8),
              Spacing.h12,
              AppTextField(
                labelText: 'ID',
                hintText: 'ID',
                controller: _idTED,
                inputFormatter: [
                  UpperCaseTextFormatter(),
                ],
              ),
              AppTextField(
                labelText: 'Serial number',
                hintText: 'Serial number',
                controller: _serialNumberTED,
                keyboardType: TextInputType.text,
              ),
              AppTextField(
                labelText: 'Remarks',
                hintText: 'Remarks',
                controller: _remarksTED,
              ),
              Spacing.h50,
              AppButton.flat(
                height: 50,
                width: Screen.width - 50,
                text: 'Cancel',
                isSecondary: true,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Spacing.h8,
              AppButton.flat(
                height: 50,
                width: Screen.width - 50,
                text: 'Save',
                onTap: () {
                  if (_idTED.text.trim().isNotEmpty) {
                    _tags.add(
                      Tag(
                        id: _idTED.text,
                        serialNumber: _serialNumberTED.text.stringOrNull,
                        remarks: _remarksTED.text.stringOrNull,
                      ),
                    );
                  }
                  Navigator.pop(context, _tags);
                },
              ),
              Spacing.h8,
              if (!_isEditMode)
                AppButton.flat(
                  height: 50,
                  width: Screen.width - 50,
                  text: 'Save & add new tag',
                  onTap: () {
                    if (_idTED.text.trim().isNotEmpty) {
                      _tags.add(
                        Tag(
                          id: _idTED.text,
                          serialNumber: _serialNumberTED.text.stringOrNull,
                          remarks: _remarksTED.text.stringOrNull,
                        ),
                      );
                      _idTED.clear();
                      _serialNumberTED.clear();
                      _remarksTED.clear();
                    }
                  },
                ),
              Spacing.h8,
            ],
          ),
        ).paddingOnly(bottom: MediaQuery.of(context).viewInsets.bottom),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
