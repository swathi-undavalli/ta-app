import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/counter_model.dart';
import '../../employees/model/employee.dart';
import '../models/equipment_log_model.dart';
import '../models/equipment_model.dart';
import '../models/otp_validation_model.dart';

class EquipmentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _equipmentItemsRef => _firestore.collection('equipmentItems');
  CollectionReference<Map<String, dynamic>> get _equipmentCategoriesRef => _firestore.collection('equipmentCategories');
  CollectionReference<Map<String, dynamic>> get _equipmentPiecesRef => _firestore.collection('equipmentPieces');
  CollectionReference<Map<String, dynamic>> get _equipmentLogsRef => _firestore.collection('equipmentLogs');
  CollectionReference<Map<String, dynamic>> get _employeesRef => _firestore.collection('employees');

  DocumentReference<Map<String, dynamic>> get _counterRef => _firestore.collection('counter').doc('count');

  Future<List<EquipmentItem>> getEquipmentItems() async {
    final querySnapshot = await _equipmentItemsRef.get();
    return querySnapshot.docs.map((doc) => EquipmentItemMapper.fromMap(doc.data())).toList();
  }

  Future<List<EquipmentLog>> getEquipmentLogs() async {
    final querySnapshot = await _equipmentLogsRef.get();
    return querySnapshot.docs.map((doc) => EquipmentLogMapper.fromMap(doc.data())).toList();
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

  Future<void> updateEquipmentItem(EquipmentItem item) async {
    await _equipmentItemsRef.doc(item.id).set(item.toMap());
  }

  Future<void> updateEquipmentPiece(EquipmentPiece piece) async {
    await _equipmentPiecesRef.doc(piece.id).set(piece.toMap());
  }

  Future<void> deleteEquipmentPiece(String pieceID) async {
    await _equipmentPiecesRef.doc(pieceID).delete();
  }

  Future<List<Employee>> getEmployees() async {
    final querySnapshot = await _employeesRef.get();
    List<Employee> employees = [];

    for (final doc in querySnapshot.docs) {
      try {
        employees.add(Employee.fromMap(doc.data()));
      } catch (e) {
        print('Error mapping ${doc.id} to Employee: $e');
      }
    }
    return employees;
  }

  void updateEquipmentPieces(List<EquipmentPiece> pieces, String? renterID, Timestamp? lastRented) {
    // Update renter and lastRented information in pieces
    for (var piece in pieces) {
      piece = piece.copyWith(currentRental: renterID, lastRented: lastRented);
      FirebaseFirestore.instance.collection('equipmentPieces').doc(piece.id).set(piece.toMap());
    }
  }

  Future<EquipmentLog> addEquipmentLog(OtpValidation validation, String notes) async {
    final querySnapshot = await _counterRef.get();
    final counter = CounterModel.fromMap(querySnapshot.data() ?? {});
    int currentID = (counter.equipmentLog ?? 0) + 1;
    EquipmentLog log = EquipmentLog(
      id: currentID.toString(),
      renterID: validation.renterID!,
      approverID: validation.approverID!,
      pieces: validation.pieces,
      notes: 'implement this',
      time: Timestamp.now(),
      collectedTime: Timestamp.now(),
    );
    await _counterRef.set(counter.copyWith(equipmentLog: currentID).toMap());
    await _equipmentLogsRef.doc(currentID.toString()).set(log.toMap());
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
    required List<Tag> assignedTags,
    required String photoURL,
  }) async {
    final equipmentItem = await addEquipmentItem(
      EquipmentItem(
        id: '', // Placeholder for ID to be set by Firestore
        category: category,
        name: name,
        photo: photoURL,
      ),
    );

    Future.wait(
      assignedTags.map(
        (tag) => addEquipmentPiece(
          EquipmentPiece(
            id: '',
            // Placeholder for ID to be set by Firestore
            tag: tag,
            equipmentItemID: equipmentItem.id,
            currentRental: null,
            lastRented: null,
            equipmentItemName: equipmentItem.name,
          ),
        ),
      ),
    );

    return equipmentItem;
  }

  Future<void> deleteItems() async {
    // final querySnapshot = await _equipmentPiecesRef.get();
    // final querySnapshot = await _equipmentItemsRef.get();
    final querySnapshot = await _equipmentLogsRef.get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<EquipmentLog> completeSubmission(EquipmentLog log) async {
    final logWithSubmissionDetails = log.copyWith(collectedTime: Timestamp.now(), collectorID: currentEmployee?.id);
    await _equipmentLogsRef.doc(logWithSubmissionDetails.id).set(logWithSubmissionDetails.toMap());
    updateEquipmentPieces(log.pieces, null, null);
    return logWithSubmissionDetails;
  }

  Future<List<EquipmentPiece>> getEquipmentPieces(String id) async {
    final querySnapshot = await _equipmentPiecesRef.where('equipmentItemID', isEqualTo: id).get();
    return querySnapshot.docs.map((doc) => EquipmentPieceMapper.fromMap(doc.data())).toList();
  }

  Future<void> deleteEquipmentItem(EquipmentItem equipmentItem) async {
    await _equipmentItemsRef.doc(equipmentItem.id).delete();

    final querySnapshot = await _equipmentPiecesRef.where('equipmentItemID', isEqualTo: equipmentItem.id).get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
