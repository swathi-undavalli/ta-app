import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/equipment_model.dart';

class EquipmentRepo {
  static Future<List<EquipmentCategory>> fetchCategories() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('equipmentCategories').get();
    return querySnapshot.docs.map((doc) => EquipmentCategoryMapper.fromMap(doc.data())).toList();
  }

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

  static Future<void> addEquipmentItem({
    required EquipmentCategory equipmentCategoryModel,
    required String equipmentName,
    required String photo,
    required List<String> equipmentIds,
  }) async {
    final newDoc = FirebaseFirestore.instance.collection('equipmentItems').doc();
    final newCategory = EquipmentItem(
      category: equipmentCategoryModel,
      id: newDoc.id,
      name: equipmentName,
      photo: photo,
    );
    await newDoc.set(newCategory.toMap());

    for (var id in equipmentIds) {
      await addEquipmentPiece(id, equipmentName);
    }
  }

  static Future<void> addEquipmentPiece(String equipmentId, String equipmentName) async {
    final newDoc = FirebaseFirestore.instance.collection('equipmentPieces').doc();

    final newEquipmentPiece = EquipmentPiece(
      id: newDoc.id,
      equipmentName: equipmentName,
      equipmentId: equipmentId,
      currentRental: null,
      lastRented: null,
    );
    await newDoc.set(newEquipmentPiece.toMap());
  }

  static Future<void> editEquipmentItem({
    required String equipmentId,
    required EquipmentCategory equipmentCategory,
    required String equipmentName,
    required String photo,
    required List<String> updatedEquipmentIds,
    required List<EquipmentPiece> equipmentPieces,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('equipmentItems').doc(equipmentId);

    final updatedData = {
      'category': equipmentCategory.toMap(),
      'name': equipmentName,
      'photo': photo,
    };
// Update the main equipment item document
    await docRef.update(updatedData);

// Update equipment pieces (logic for add, remove)
    await updateEquipmentPieces(updatedEquipmentIds, equipmentName, equipmentPieces);
  }

  static Future<void> updateEquipmentPieces(
    List<String> updatedIds,
    String equipmentName,
    List<EquipmentPiece> existingPieces,
  ) async {
    for (final id in updatedIds) {
      if (!existingPieces.any((piece) => piece.equipmentId == id)) {
        // Add new piece if it doesn't exist
        addEquipmentPiece(id, equipmentName);
      }
    }

    // Delete pieces not in updatedIds
    for (final piece in existingPieces) {
      if (!updatedIds.contains(piece.equipmentId)) {
        await FirebaseFirestore.instance.collection('equipmentPieces').doc(piece.id).delete();
      }
    }
  }

  static Future<List<EquipmentPiece>> fetchEquipmentPieces() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('equipmentPieces').get();
    return querySnapshot.docs.map((doc) => EquipmentPieceMapper.fromMap(doc.data())).toList();
  }

  static Future<List<EquipmentPiece>> fetchEquipmentPiecesByEquipmentName(String equipmentName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('equipmentPieces')
        .where('equipmentName', isEqualTo: equipmentName)
        .get();
    return querySnapshot.docs.map((doc) => EquipmentPieceMapper.fromMap(doc.data())).toList();
  }
}
