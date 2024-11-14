import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/equipment_model.dart';

//TODO: remove after moving to equipment.repository.dart
class EquipmentRepo {
  static Future<void> editCategory(EquipmentCategory equipmentCategoryModel) async {
    await FirebaseFirestore.instance
        .collection('equipmentCategories')
        .doc(equipmentCategoryModel.id)
        .update(equipmentCategoryModel.toMap());
  }

  static Future<EquipmentCategory> addCategory(String categoryName) async {
    final newDoc = FirebaseFirestore.instance.collection('equipmentCategories').doc();
    final newCategory = EquipmentCategory(name: categoryName, id: newDoc.id);
    await newDoc.set(newCategory.toMap());
    return newCategory;
  }

  static Future<void> deleteCategory(String docId) async {
    await FirebaseFirestore.instance.collection('equipmentCategories').doc(docId).delete();
  }
}
