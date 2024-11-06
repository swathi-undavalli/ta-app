import 'package:flutter/material.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';

import '../../models/equipment_category_model.dart';

class EquipmentSelectorBottomSheet extends StatefulWidget {
  const EquipmentSelectorBottomSheet({
    super.key,
  });

  static void show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return const EquipmentSelectorBottomSheet();
      },
    );
  }

  @override
  State<EquipmentSelectorBottomSheet> createState() => _EquipmentSelectorBottomSheetState();
}

class _EquipmentSelectorBottomSheetState extends State<EquipmentSelectorBottomSheet> {
  List<EquipmentCategoryModel> categories = [];
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    // categories = await fetchCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 30,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitleAndClose().paddingSymmetric(horizontal: 20),
          Spacing.h20,
          buildCategoryList(),
          Spacing.h20,
          buildAddCategoryButton(),
          Spacing.h20,
        ],
      ),
    );
  }

  Widget buildTitleAndClose() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Manage Equipment',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (!showLoading) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Widget buildCategoryList() {
    return Expanded(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(
              category.categoryName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                _showCategoryDialog(
                  context,
                  initialCategory: category.categoryName,
                  onSave: (updatedCategoryName) async {
                    // await editCategory(category.id, updatedCategoryName);
                    await loadCategories();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildAddCategoryButton() {
    return ListTile(
      title: const Center(
        child: Text(
          'Add Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      onTap: () {
        _showCategoryDialog(
          context,
          onSave: (newCategoryName) async {
            // await addCategory(newCategoryName);
            await loadCategories();
          },
        );
      },
    );
  }

  void _showCategoryDialog(BuildContext context, {String? initialCategory, required Function(String) onSave}) {
    TextEditingController controller = TextEditingController(text: initialCategory ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            initialCategory == null ? 'Add New Category' : 'Edit Category',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter category name', hintStyle: TextStyle(fontSize: 12)),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            if (initialCategory != null)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            TextButton(
              onPressed: () {
                String category = controller.text.trim();
                if (category.isNotEmpty) {
                  onSave(category);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                initialCategory == null ? 'Add' : 'Save',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
