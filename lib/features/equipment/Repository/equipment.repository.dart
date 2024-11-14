import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/equipment_log_model.dart';
import '../models/equipment_model.dart';
import '../models/otp_validation_model.dart';

class EquipmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _equipmentItemsRef => _firestore.collection('equipmentItems');

  CollectionReference<Map<String, dynamic>> get _equipmentCategoriesRef => _firestore.collection('equipmentCategories');

  CollectionReference<Map<String, dynamic>> get _equipmentPiecesRef => _firestore.collection('equipmentPieces');

  CollectionReference<Map<String, dynamic>> get _equipmentLogsRef => _firestore.collection('equipmentLogs');

  Future<List<EquipmentItem>> getEquipmentItems() async {
    final querySnapshot = await _equipmentItemsRef.get();
    return querySnapshot.docs.map((doc) => EquipmentItemMapper.fromMap(doc.data())).toList();
  }

  Future<List<EquipmentCategory>> getCategories() async {
    final querySnapshot = await _equipmentCategoriesRef.get();
    return querySnapshot.docs.map((doc) => EquipmentCategoryMapper.fromMap(doc.data())).toList();
  }

  Future<EquipmentItem> addEquipmentItem(EquipmentItem item) async {
    final newDoc = _equipmentItemsRef.doc();
    final itemWithId = item.copyWith(id: newDoc.id);
    await newDoc.set(itemWithId.toMap());
    return itemWithId;
  }

  Future<EquipmentLog> addEquipmentLog(OtpValidation validation, String notes) async {
    final newDoc = _equipmentLogsRef.doc();
    EquipmentLog log = EquipmentLog(
      id: newDoc.id,
      renterID: validation.renterID!,
      approverID: validation.approverID!,
      pieces: validation.pieces,
      notes: 'implement this',
      time: Timestamp.now(),
    );
    await newDoc.set(log.toMap());
    return log;
  }

  Future<EquipmentPiece> addEquipmentPiece(EquipmentPiece piece) async {
    final newDoc = _equipmentPiecesRef.doc();
    final pieceWithId = piece.copyWith(id: newDoc.id);
    await newDoc.set(pieceWithId.toMap());
    return pieceWithId;
  }

  Future<List<EquipmentPiece>> fetchEquipmentPieces({
    String? equipmentItemId,
    required String? currentRental,
  }) async {
    Query<Map<String, dynamic>> query = _equipmentPiecesRef;

    if (equipmentItemId != null) {
      query = query.where('equipmentItemID', isEqualTo: equipmentItemId);
    }
    if (currentRental == null) {
      query = query.where('currentRental', isNull: true);
    } else {
      query = query.where('currentRental', isEqualTo: currentRental);
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => EquipmentPieceMapper.fromMap(doc.data())).toList();
  }

  /// Adds a new equipment item and then create multiple equipment pieces without await
  Future<EquipmentItem> addNewEquipment({
    required EquipmentCategory category,
    required String name,
    required List<String> assignedIDs,
    required String photoURL,
  }) async {
    final equipmentItem = await addEquipmentItem(EquipmentItem(
      category: category,
      name: name,
      id: '', // Placeholder for ID to be set by Firestore
      photo: photoURL,
    ));

    Future.wait(
      assignedIDs.map(
        (id) => addEquipmentPiece(EquipmentPiece(
          id: '',
          // Placeholder for ID to be set by Firestore
          assignedID: id,
          equipmentItemID: equipmentItem.id,
          currentRental: null,
          lastRented: null,
        )),
      ),
    );

    return equipmentItem;
  }
}
