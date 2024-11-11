import 'package:flutter/material.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';

import '../../Repository/equipment_repo.dart';
import '../../models/equipment_model.dart';

class CategorySelectorBottomSheet extends StatefulWidget {
  const CategorySelectorBottomSheet({
    super.key,
    required this.categories,
  });

  final List<EquipmentCategory> categories;

  static Future<List<EquipmentCategory>> show(
    BuildContext context,
    List<EquipmentCategory> equipmentCategoryModel,
  ) async {
    List<EquipmentCategory> data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (BuildContext context) {
        return CategorySelectorBottomSheet(categories: equipmentCategoryModel);
      },
    );
    return data;
  }

  @override
  State<CategorySelectorBottomSheet> createState() => _CategorySelectorBottomSheetState();
}

class _CategorySelectorBottomSheetState extends State<CategorySelectorBottomSheet> {
  List<EquipmentCategory> categories = [];
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
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
        children: (showLoading == true)
            ? [
                const CircularProgressIndicator(color: Colors.black).paddingOnly(top: 100).center,
              ]
            : [
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
          'Manage Categories',
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
              Navigator.pop(context, categories);
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
          EquipmentCategory category = categories[index];
          return ListTile(
            title: Text(
              category.name,
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
                  initialCategory: category,
                  onSave: (updatedCategoryName) async {
                    showLoading = true;
                    setState(() {});

                    EquipmentCategory equipmentCategoryModel =
                        EquipmentCategory(name: updatedCategoryName, id: category.id);

                    await EquipmentRepo.editCategory(equipmentCategoryModel);

                    categories[index] = categories[index].copyWith(name: updatedCategoryName);

                    showLoading = false;
                    setState(() {});
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
            showLoading = true;
            setState(() {});

            EquipmentCategory newCategory = await EquipmentRepo.addCategory(newCategoryName);
            categories.add(newCategory);

            showLoading = false;
            setState(() {});
          },
        );
      },
    );
  }

  void _showCategoryDialog(
    BuildContext context, {
    EquipmentCategory? initialCategory,
    required Function(String) onSave,
  }) {
    TextEditingController controller = TextEditingController(text: initialCategory?.name ?? '');

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
                onPressed: () async {
                  showLoading = true;
                  setState(() {});
                  await EquipmentRepo.deleteCategory(initialCategory.id);

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  showLoading = false;
                  setState(() {});
                },
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
